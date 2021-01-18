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
      # An array with duration ranges 
      #
      # type: [Range<ActiveSupport::Duration>]
      # example: [(7.hours + 30.minutes)..12.hours, 13.hours..18.hours]
      #
      :time_windows,
      # 
      # Self-explanatory
      #
      :ubs_id,
      #
      # Appointment duration
      #
      # type: ActiveSupport::Duration
      # example: 20.minutes
      #
      :appointment_duration,
      # 
      # Number of vaccination spots (i.e. parallel appointments)
      # 
      # type: Integer
      #
      :num_spots,
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
      raise "Time slot generation options must be a hash" if \
        !options.is_a?(Hash)

      raise "Missing or extra time slot generation options" if \
        options.symbolize_keys.keys.sort != Names.sort

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
      options.time_windows.each do |window|
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
    window.step(options.appointment_duration).lazy.each do |time|
      window_start = date + window.begin
      window_end = date + window.end
      appointment_start = date + time
      appointment_end = appointment_start + options.appointment_duration

      next if appointment_end > window_end

      options.num_spots.times do 
        @create_slot.({
          ubs_id: options.ubs_id,
          start: appointment_start,
          end: appointment_end,
          patient_id: nil
        }.with_indifferent_access)
      end
    end
  end
end
