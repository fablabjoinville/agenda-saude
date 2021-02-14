class ReceptionService
  def initialize(appointment)
    @appointment = appointment
    @patient = appointment.patient
  end

  def check_in
    @appointment.update!(check_in: Time.zone.now)
  end

  def check_out
    Appointment.transaction do
      @appointment.update!(check_out: Time.zone.now)

      create_second_dose_appointment unless @appointment.second_dose?
    end
  end

  private

  def create_second_dose_appointment
    next_appointment = Appointment.where(
      start: @appointment.start + ENV['SECOND_DOSE_INTERVAL'].to_i.weeks,
      patient_id: nil
    ).first

    next_appointment.update!(patient_id: @patient.id, second_dose: true)
    @patient.update(last_appointment: next_appointment)
  end
end
