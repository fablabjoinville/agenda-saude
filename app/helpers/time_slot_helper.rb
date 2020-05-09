module TimeSlotHelper
  OFFICIAL_HOLIDAYS = %w[01-01 10-04 20-04 21-04 01-05 11-06 12-06 07-09 12-10 28-10 02-11 15-11 21-12 22-12 23-12 24-12 25-12 28-12 29-12 30-12 31-12].freeze

  def business_day?(day)
    formated_day = day.strftime('%d-%m')

    OFFICIAL_HOLIDAYS.exclude?(formated_day) && day.on_weekday?
  end
end
