module TimeSlot
  OFFICIAL_HOLIDAYS = %w[01-01 02-01 10-04 20-04 21-04 01-05 11-06 12-06 07-09 12-10 13-10 28-10 02-11 15-11 21-12 22-12 23-12 24-12 25-12 26-12 28-12 29-12 30-12 31-12].freeze

  # TODO: Extract to helper
  def business_day?(day, open_sat)
    formated_day = day.strftime('%d-%m')

    if open_sat
      OFFICIAL_HOLIDAYS.exclude?(formated_day) && (day.on_weekday? || day.saturday?)
    else
      OFFICIAL_HOLIDAYS.exclude?(formated_day) && day.on_weekday?
    end
  end

  def available_time_slots(time_now, available_time_slot_days)
    day_range = build_weekdays_date_range(available_time_slot_days)

    slots_for_day = day_range.each_with_object({}) do |day, slots|
      slots[day] = available_time_slots_for_day(day, time_now)
    end

    slots_for_day.reject do |_day, slots|
      slots.empty?
    end
  end

  def available_time_slots_for_day(day, time_now)
    appointments = Appointment.where(ubs: self).start_between(day.beginning_of_day, day.end_of_day)

    if day.saturday?
      all_time_slots = time_slots(morning_saturday(day)) + time_slots(afternoon_saturday(day))
    else
      all_time_slots = time_slots(morning_shift(day)) + time_slots(afternoon_shift(day))
    end

    if day.today?
      all_time_slots.reject! do |slot|
        slot[:slot_start].to_i < time_now.to_i
      end
    end

    all_time_slots - time_slots_conflicts(all_time_slots, appointments)
  end

  private

  def build_weekdays_date_range(available_days)
    day_range = []
    d = 0
    i = 0
    until d == available_days
      day = i.days.from_now
      if business_day?(day, self.open_saturday)
        day_range << day
        d += 1
      end
      # if want increment only available days, move the line below to inside 'if business_day'
      i += 1
    end
    day_range
  end

  def time_slots_conflicts(time_slots, appointments)
    conflicts = time_slots.product(appointments).select do |time_slot, appointment|
      conflicting?(time_slot, appointment)
    end

    conflicts.map { |time_slot, _appointment| time_slot }
  end

  def conflicting?(time_slot, appointment)
    start_slot = time_slot[:slot_start]
    end_slot = time_slot[:slot_end]

    start_slot.between?(appointment.start, appointment.end-1) ||
      end_slot.between?(appointment.start+1, appointment.end)
      # TODO fix when appointment begins and ends between start_slot and end_slot
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
