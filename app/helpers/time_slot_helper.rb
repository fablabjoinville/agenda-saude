module TimeSlotHelper
  OFFICIAL_HOLIDAYS = %w[01-01 10-04 21-04 01-05 07-09 12-10 02-11 15-11 25-11].freeze

  def business_day?(day)
    formated_day = day.strftime('%d-%m')

    OFFICIAL_HOLIDAYS.exclude?(formated_day) && day.on_weekday?
  end
end
