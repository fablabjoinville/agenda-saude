class TimeSlotGenerationService
  class Options < OpenStruct
    Names = [
      #
      # ID of the UBS for which the time slots should be generated
      #
      # type: Int
      #
      :ubs_id,
      #
      # Date from which time slots should be generated
      #
      # type: DateTime
      #
      :start_date,
      #
      # Final date for which time slots should be generated
      #
      # type: DateTime
      #
      :end_date,
      #
      # Operating weekdays. Sunday = 0
      #
      # type: [Int]
      # example: [*1..5] # Monday to Friday
      #
      :weekdays,
      #
      # Dates for which time slots should not be generated
      #
      # type: [Date]
      #
      :excluded_dates,
      #
      # Time windows to generate slots for
      #
      # type: [Hash]
      # example: { start_time: '10:00', end_time: '12:00', slots: 10 }
      #
      :windows,
      #
      # The duration each time slot should take in minutes
      #
      # type: Int
      #
      :slot_interval_minutes,
    ]

    def initialize(options)
      raise "Time slot generation options must be a hash" \
        unless options.is_a?(Hash)

      raise "Missing or extra time slot generation options" \
        unless options.symbolize_keys.keys.sort == Names.sort

      super(options)
    end
  end
  #
  # create_slot:
  #   A function receiving a hash with generated time slot attributes
  #
  def initialize(create_slot:)
    @create_slot = create_slot
  end

  def execute(options)
    date_range = build_date_range(options)

    date_range.lazy.each do |date|
      next if date_should_be_excluded?(date, options)

      options.windows.each do |window|
        generate_time_slots_for_time_window(date, window, options)
      end
    end
  end

  private

  def date_should_be_excluded?(date, options)
    options.weekdays.exclude?(date.wday) || date.in?(options.excluded_dates)
  end

  def build_date_range(options)
    options.start_date.at_beginning_of_day..options.end_date.at_end_of_day
  end

  def generate_time_slots_for_time_window(date, window, options)
    window_range = build_time_window(window)

    appointment_duration = options.slot_interval_minutes.minutes

    report = {}

    window_range.step(appointment_duration).lazy.each do |time|
      appointment_start = date + time
      appointment_end = appointment_start + appointment_duration

      next if appointment_end > date + window_range.end

      taken_slots_count = Appointment.where(start: appointment_start, ubs_id: options.ubs_id).count
      new_slots_count = window[:slots] - taken_slots_count

      report[appointment_start.to_s] = { taken_slots_count: taken_slots_count, new_slots_count: new_slots_count }

      new_slots_count.times do
        @create_slot.({
          ubs_id: options.ubs_id,
          start: appointment_start,
          end: appointment_end,
          active: true,
          patient_id: nil
        }.with_indifferent_access)
      end
    end

    pp report unless Rails.env.test?
  end

  def build_time_window(window)
    window_start = string_to_duration(window[:start_time])
    window_end = string_to_duration(window[:end_time])

    window_start..window_end
  end

  def string_to_duration(hour_min_string)
    parts = hour_min_string.split(':')

    parts[0].to_i.hours + parts[1].to_i.minutes
  end
end
