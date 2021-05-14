class TimeSlotGenerationService
  attr_reader :ubs

  def call(ubs:, from:, to:, default_attributes: {})
    @ubs = ubs

    (from..to).map do |date|
      ubs.time_windows(date.wday).map do |window|
        create_appointments_for_day(
          day: Time.zone.parse("#{date} 00:00:00"),
          hours_range: window[0].to_i..window[1].to_i,
          default_attributes: default_attributes
        )
      end
    end
  end

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_appointments_for_day(day:, hours_range:, default_attributes:)
    report = {}
    to_be_created = []

    hours_range.step(ubs.slot_interval_minutes.minutes).lazy.each do |time|
      appointment_start = day + time
      appointment_end = appointment_start + ubs.slot_interval_minutes.minutes

      next if appointment_end > day + hours_range.end

      taken_slots_count = Appointment.where(start: appointment_start, ubs_id: ubs.id).count
      new_slots_count = ubs.appointments_per_time_slot - taken_slots_count

      attributes = {
        ubs_id: ubs.id,
        start: appointment_start,
        end: appointment_end,
        active: true,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }.with_indifferent_access.merge(default_attributes.with_indifferent_access)

      to_be_created << Array.new([0, new_slots_count].max, attributes)

      report[appointment_start] = { taken: taken_slots_count, created: new_slots_count }
    end

    create!(to_be_created)

    report
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def create!(array_of_attributes)
    array_of_attributes.flatten!
    Appointment.insert_all!(array_of_attributes) if array_of_attributes.any? # rubocop:disable Rails/SkipsModelValidations
  end

  def string_to_duration(hour_min_string)
    parts = hour_min_string.split(':')

    parts[0].to_i.hours + parts[1].to_i.minutes
  end
end
