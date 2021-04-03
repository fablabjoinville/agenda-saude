class Dose < ApplicationRecord
  belongs_to :patient
  belongs_to :schedule
  belongs_to :vaccine
end
