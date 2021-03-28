class Appointment < ApplicationRecord
  belongs_to :ubs
  belongs_to :patient, optional: true
  belongs_to :group, optional: true

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 7

  scope :start_between, -> (from, to) { where(start: from..to) }

  scope :today, -> { start_between(Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }

  scope :without_checkout, -> { where(check_out: nil) }

  scope :future, -> { where(arel_table[:start].gt(Time.zone.now)) }

  scope :free, -> { left_joins(:ubs).where(ubs: { active: true }).where(patient_id: nil) }

  scope :active, -> { where(active: true) }

  def active?
    active
  end

  def in_allowed_check_in_window?
    start > Time.zone.now.beginning_of_day && start < Time.zone.now.end_of_day
  end

  def patient_group
    if group_id.nil? && min_age.positive? && commorbidity == false
      groups_description = "População em geral com #{min_age} anos ou mais"
    elsif group_id.nil? && min_age.positive? && commorbidity == true
      groups_description = "População em geral com #{min_age} anos ou mais que tenha alguma comorbidade"
    elsif !group_id.nil? && min_age.positive? && commorbidity == false
      groups_description = "#{group.name} com #{min_age} anos ou mais"
    elsif !group_id.nil? && min_age.positive? && commorbidity == true
      groups_description = "#{group.name} com #{min_age} anos ou mais que tenha alguma comorbidade"
    end
    groups_description
  end
end
