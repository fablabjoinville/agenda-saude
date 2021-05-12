class Vaccine < ApplicationRecord
  has_many :doses, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :formal_name, presence: true

  # To ensure we get +nil+ instead of +""+
  def second_dose_after_in_days=(days)
    self[:second_dose_after_in_days] = days.presence
  end

  # To ensure we get +nil+ instead of +""+
  def third_dose_after_in_days=(days)
    self[:third_dose_after_in_days] = days.presence
  end

  def follow_up_in_days(sequence_number)
    case sequence_number.to_i
    when 1
      second_dose_after_in_days.presence
    when 2
      third_dose_after_in_days.presence
    end
  end
end
