class Appointment < ApplicationRecord
  belongs_to :ubs
  belongs_to :patient, optional: true

  scope :today, -> { where('date(start) = ?', Date.current) }
  scope :active_from_day, ->(day) do
    where('start >= ? AND appointments.end <= ?', day.beginning_of_day, day.end_of_day)
  end

  scope :futures, -> { where('start > ?', Time.current) }

  def active?
    active == true
  end
end
