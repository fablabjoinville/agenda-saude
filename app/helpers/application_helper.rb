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
end
