module ApplicationHelper
  def self.humanize_datetime(date)
    date.strftime("%d/%m/%Y às %H:%M")
  end

  def self.humanize_date(date)
    date.strftime("%d/%m/%Y")
  end

  def self.humanize_time(date)
    date.strftime("%H:%M")
  end

  def business_day?(day, open_sat)
    formated_day = day.strftime('%d-%m')

    if open_sat
      if day.on_weekday?
        OFFICIAL_HOLIDAYS.exclude?(formated_day) && day.on_weekday?
      else
        day.saturday?
      end
    else
      OFFICIAL_HOLIDAYS.exclude?(formated_day) && day.on_weekday?
    end
  end
end
