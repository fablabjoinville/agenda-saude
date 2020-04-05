class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :ubs

  scope :active_from_day, ->(day) do
    where(active: true).where('start >= ? AND appointments.end <= ?', day.beginning_of_day, day.end_of_day)
  end
end
