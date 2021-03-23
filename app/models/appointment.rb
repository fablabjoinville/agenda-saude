class Appointment < ApplicationRecord
  belongs_to :ubs
  belongs_to :patient, optional: true

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 7

  scope :start_between, -> (from, to) { where(start: from..to) }
  scope :today, -> { start_between(Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }
  scope :without_checkout, -> { where(check_out: nil) }
  scope :futures, -> { where(arel_table[:start].gt(Time.zone.now)) }
  scope :free, -> { joins(:ubs).where(ubs: { active: true }).where(patient_id: nil) }

  def active?
    active
  end

  def in_allowed_check_in_window?
    start > Time.zone.now.beginning_of_day && start < Time.zone.now.end_of_day
  end
end
