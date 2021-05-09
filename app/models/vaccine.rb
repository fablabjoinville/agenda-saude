class Vaccine < ApplicationRecord
  has_many :doses, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :formal_name, presence: true

  def follow_up_in_days(sequence_number)
    case sequence_number.to_i
    when 1
      second_dose_after_in_days.presence
    when 2
      third_dose_after_in_days.presence
    end
  end
end
