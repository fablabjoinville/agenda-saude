class ReceptionService
  VACCINES_SECOND_DOSE_INTERVAL = {
    'coronavac' => 4.weeks,
    'astra_zeneca' => 13.weeks
  }.freeze

  def initialize(patient)
    @patient = patient
  end

  def check_in
    current_appointment.update!(check_in: Time.zone.now)
  end

  def check_out(vaccine_name)
    current_appointment.update!(check_out: Time.zone.now, vaccine_name: vaccine_name)

    create_second_dose_appointment(vaccine_name) unless current_appointment.second_dose?
  end

  private

  def current_appointment
    @patient.last_appointment
  end

  def create_second_dose_appointment(vaccine_name)
    next_appointment_start = current_appointment.start + VACCINES_SECOND_DOSE_INTERVAL[vaccine_name]
    next_appointment_end = next_appointment_start + current_appointment.ubs.slot_interval_minutes.minutes

    next_appointment = Appointment.create!(
      start: next_appointment_start,
      end: next_appointment_end,
      patient_id: @patient.id,
      second_dose: true,
      active: true,
      vaccine_name: vaccine_name,
      ubs: current_appointment.ubs
    )

    @patient.update(last_appointment: next_appointment)
  end
end
