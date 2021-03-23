class Appointment < ApplicationRecord
  belongs_to :ubs
  belongs_to :patient, optional: true

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 7

  scope :available_for, lambda { |date|
    where(start: date..date.end_of_day, patient: nil) # all free appointments for the day
      .order(:start) # in chronological order
  }
  scope :today, -> { where('date(start) = ?', Date.current) }
  scope :without_checkout, -> { where(check_out: nil) }
  scope :active_from_day, ->(day) do
    where('start >= ? AND appointments.end <= ?', day.beginning_of_day, day.end_of_day)
  end

  scope :futures, -> { where('start > ?', Time.zone.now) }

  scope :free, -> { joins(:ubs).where(ubs: { active: true }).where(patient_id: nil) }

  scope :within_allowed_window, -> {
    where(start: Time.zone.now..(Time.zone.now + SLOTS_WINDOW_IN_DAYS.days).end_of_day)
  }

  def active?
    active == true
  end

  def in_allowed_check_in_window?
    start > Time.zone.now.beginning_of_day && start < Time.zone.now.end_of_day
  end
end
