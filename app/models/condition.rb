class Condition < ApplicationRecord
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :ubs

  validates :name, :start_at, presence: true
  validates :min_age, :max_age,
            numericality: { only_integer: true, allow_nil: true,
                            greater_than_or_equal_to: 0, less_than_or_equal_to: 120 }
  validates :min_age, :max_age, :groups,
            presence: {
              if: proc { |c| c.min_age.blank? && c.max_age.blank? && group_ids.empty? },
              message: 'deve ser escolhida se nenhuma outra o for.'
            }

  scope :start_at_past, -> { where('start_at <= NOW()') }
  scope :end_at_future, -> { where('NOW() < end_at') }

  scope :active, -> { start_at_past.end_at_future }
  scope :can_register, -> { where(can_register: true) }
  scope :can_schedule, -> { where(can_schedule: true) }

  def active?
    start_at <= Time.zone.now && Time.zone.now < end_at
  end

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
