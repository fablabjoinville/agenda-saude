class TimeSlotGenerationService
  class Options < OpenStruct
    Names = [
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
      # Self-explanatory
      #
      # Type: Ubs (model)
      #
      :ubs,
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
      build_ubs_time_windows(options.ubs).each do |window|
        generate_time_slots_for_time_window(date, window, options)
      end
    end
  end

  def date_should_be_excluded?(date, options)
    options.weekdays.exclude?(date.wday) || date.in?(options.excluded_dates)
  end

  def build_date_range(options)
    options.start_date.at_beginning_of_day..options.end_date.at_end_of_day
  end

  def generate_time_slots_for_time_window(date, window, options)
    appointment_duration = options.ubs.slot_interval_minutes.minutes
    window.step(appointment_duration).lazy.each do |time|
      window_end = date + window.end
      appointment_start = date + time
      appointment_end = appointment_start + appointment_duration

      next if appointment_end > window_end

      options.ubs.appointments_per_time_slot.times do
        @create_slot.({
          ubs_id: options.ubs.id,
          start: appointment_start,
          end: appointment_end,
          active: true,
          patient_id: nil
        }.with_indifferent_access)
      end
    end
  end

  def build_ubs_time_windows(ubs)
    shift_start = string_to_duration(ubs.shift_start)
    break_start = string_to_duration(ubs.break_start)

    break_end = string_to_duration(ubs.break_end)
    shift_end = string_to_duration(ubs.shift_end)

    [shift_start..break_start, break_end..shift_end]
  end

  def string_to_duration(hour_min_string)
    parts = hour_min_string.split(':')

    parts[0].to_i.hours + parts[1].to_i.minutes
  end
end
