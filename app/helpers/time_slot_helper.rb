module TimeSlotHelper
  OFFICIAL_HOLIDAYS = %w[01-01 10-04 20-04 21-04 01-05 11-06 12-06 13-06 07-09 12-10 13-10 28-10 02-11 15-11 21-12 22-12 23-12 24-12 25-12 28-12 29-12 30-12 31-12].freeze

  def business_day?(day)
    formated_day = day.strftime('%d-%m')

    OFFICIAL_HOLIDAYS.exclude?(formated_day) && day.on_weekday?
  end

  private

  def build_weekdays_date_range(available_days)
    day_range = []
    d = 0
    i = 0
    until d == available_days
      day = i.days.from_now
      if business_day?(day)
        day_range << day
        d += 1
      end
      # if want increment only available days, move the line below to inside 'if business_day'
      i += 1
    end
    day_range
  end

end
