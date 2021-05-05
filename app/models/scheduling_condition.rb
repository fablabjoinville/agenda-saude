class SchedulingCondition < ApplicationRecord
  has_and_belongs_to_many :groups

  validates :name, :start_at, presence: true
  validates :min_age, :max_age, numericality: { only_integer: true, allow_nil: true,
                                                greater_than_or_equal_to: 0, less_than_or_equal_to: 120 }

  scope :enabled, -> { where(active: true).where('start_at < NOW()') }

  def allowed?(patient)
    allowed_min_age?(patient) && allowed_max_age?(patient) && allowed_groups?(patient)
  end

  def allowed_min_age?(patient)
    min_age.blank? ||
      patient.age >= min_age
  end

  def allowed_max_age?(patient)
    max_age.blank? ||
      patient.age <= max_age
  end

  def allowed_groups?(patient)
    group_ids.empty? ||
      (group_ids & patient.group_ids).any?
  end
end
