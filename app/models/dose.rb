class Dose < ApplicationRecord
  belongs_to :patient
  belongs_to :appointment
  belongs_to :vaccine
  belongs_to :follow_up_appointment, optional: true, class_name: "Appointment"
end
