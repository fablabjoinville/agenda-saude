Appointment.where(patient_id: nil).update_all(patient_id: 42) # rubocop:disable Rails/SkipsModelValidations
