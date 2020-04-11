module TimeSlot
  def available_time_slots(day_range, current_time)
    slots_for_day = day_range.each_with_object({}) do |day, slots|
      slots[day] = available_time_slots_for_day(day)

      if day.today?
        slots[day].reject! do |slot|
          slot[:slot_start].to_i < current_time.to_i
        end
      end
    end

    slots_for_day.reject do |_day, slots|
      slots.empty?
    end
  end

  private

  def available_time_slots_for_day(day)
    appointments = Appointment.where(ubs: self).active_from_day(day)
    schedules = appointments.map { |appointment| [appointment.start, appointment.end] }

    all_time_slots = time_slots(morning_shift(day)) + time_slots(afternoon_shift(day))

    all_time_slots - time_slots_conflicts(all_time_slots, schedules)
  end

  def time_slots_conflicts(all_time_slots, schedules)
    conflicts = []

    schedules.each do |schedule|
      all_time_slots.each do |time_slot|
        already_scheduled_time_frame = (schedule[0].to_i + 1..schedule[1].to_i - 1).to_a

        start_slot = time_slot[:slot_start].to_i
        end_slot = time_slot[:slot_end].to_i

        # If the beginning of new slot is in an already scheduled appointment
        conflicts << time_slot if start_slot.in?(already_scheduled_time_frame)

        # If the end of new slot is in an already scheduled appointment
        conflicts << time_slot if end_slot.in?(already_scheduled_time_frame)

        # If the new slot contain an already scheduled appointment inside it
        if start_slot < already_scheduled_time_frame[0] && end_slot > already_scheduled_time_frame[-1]
          conflicts << time_slot
        end
      end
    end
    conflicts
  end

  def time_slots(time_range)
    interval_seconds = slot_interval.seconds

    time_range.step(interval_seconds).each_with_object([]) do |start_timestamp, slots|
      slot_start = Time.zone.at(start_timestamp)

      slots << {
        slot_start: slot_start,
        slot_end: slot_start + slot_interval
      }
    end
  end

  def time_of_day(time, date)
    Tod::TimeOfDay.parse(time).on(date).in_time_zone
  end
end
