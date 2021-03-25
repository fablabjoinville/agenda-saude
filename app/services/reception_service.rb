class ReceptionService
  VACCINES_SECOND_DOSE_INTERVAL = {
    'coronavac' => 4.weeks,
    'astra_zeneca' => 13.weeks
  }.freeze

  def initialize(appointment)
    @appointment = appointment
  end

  def check_in
    @appointment.update!(check_in: Time.zone.now)
  end

  def check_out(vaccine_name)
    Appointment.transaction do
      @appointment.update!(check_out: Time.zone.now, vaccine_name: vaccine_name)

      create_second_dose_appointment(vaccine_name) if @appointment.patient.appointments.active.checked_out.size < 2
    end
  end

  private

  def create_second_dose_appointment(vaccine_name)
    next_appointment_start = @appointment.start + VACCINES_SECOND_DOSE_INTERVAL[vaccine_name]
    next_appointment_end = next_appointment_start + @appointment.ubs.slot_interval_minutes.minutes

    Appointment.create!(
      start: next_appointment_start,
      end: next_appointment_end,
      patient_id: @appointment.patient.id,
      second_dose: true,
      active: true,
      vaccine_name: vaccine_name,
      ubs: @appointment.ubs
    )
  end
end
