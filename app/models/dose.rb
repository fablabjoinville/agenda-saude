class Dose < ApplicationRecord
  belongs_to :patient
  belongs_to :appointment
  belongs_to :vaccine
end
