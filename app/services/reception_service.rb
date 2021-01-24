class ReceptionService
  def initialize(patient)
    @patient = patient
  end

  def check_in
    current_appointment.update!(check_in: Time.zone.now)
  end

  def check_out
    current_appointment.update!(check_out: Time.zone.now)

    create_second_dose_appointment unless current_appointment.second_dose?
  end

  private

  def current_appointment
    Appointment.find_by(
      patient_id: @patient.id,
      start: @patient.last_appointment
    )
  end

  def create_second_dose_appointment
    next_appointment = Appointment.find_by(start: current_appointment.start + ENV['SECOND_DOSE_INTERVAL'].to_i.weeks)

    next_appointment.update!(patient_id: @patient.id, second_dose: true)
    @patient.update(last_appointment: next_appointment.start)
  end
end
