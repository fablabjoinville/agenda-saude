module TimeSlot
  def available_time_slots(day_range)
    day_range.each_with_object({}) do |day, slots|
      slots[day] = available_time_slots_for_day(day)
    end
  end

  private

  def available_time_slots_for_day(day)
    appointments = Appointment.where(ubs: self).from_day(day)

    scheduled_timestamps = appointments.map { |appointment| appointment.start }

    all_time_slots = time_slots(morning_shift(day)) + time_slots(afternoon_shift(day))

    all_time_slots.reject { |time_slot| time_slot[:slot_start].in?(scheduled_timestamps) }
  end

  def time_slots(time_range)
    interval_seconds = slot_interval.seconds

    time_range.step(interval_seconds).each_with_object([]) do |start_timestamp, slots|
      slot_start = Time.at(start_timestamp)

      slots << {
        slot_start: slot_start,
        slot_end: slot_start + slot_interval
      }
    end
  end

  def time_of_day(time, date)
    Tod::TimeOfDay.parse(time).on(date).to_time
  end
end
