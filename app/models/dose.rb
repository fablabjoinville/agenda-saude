class Dose < ApplicationRecord
  belongs_to :patient
  belongs_to :appointment
  belongs_to :vaccine
  belongs_to :follow_up_appointment, optional: true, class_name: 'Appointment'

  def follow_up_in_days
    vaccine.follow_up_in_days(sequence_number)
  end

  def next_sequence_number
    sequence_number + 1
  end
end
