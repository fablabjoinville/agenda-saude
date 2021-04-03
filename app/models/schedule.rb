class Schedule < ApplicationRecord
  belongs_to :appointment
  belongs_to :patient
  has_one :dose, dependent: :restrict_with_exception
end
