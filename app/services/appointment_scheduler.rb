class AppointmentScheduler
  def initialize(max_schedule_time_ahead:)
    @max_schedule_time_ahead = if max_schedule_time_ahead.is_a?(ActiveSupport::Duration)
      max_schedule_time_ahead
    else
      max_schedule_time_ahead.days
    end
  end

  def schedule(raw_start_time:, ubs:, patient:)
    start_time = Time.parse(raw_start_time)

    return [:inactive_ubs] unless ubs.active?

    Appointment.transaction do
      patient.reload

      return [:schedule_conditions_unmet] unless patient.can_schedule?
      return [:invalid_schedule_time] if start_time > (Time.now.in_time_zone + @max_schedule_time_ahead).at_end_of_day

      unless Appointment.where(start: start_time, ubs: ubs, patient_id: nil).exists?
        return [:all_slots_taken]
      end

      Appointment.where(patient_id: patient.id).futures.each do |appointment|
        appointment.update(patient_id: nil)
      end

      appointment = Appointment.where(start: start_time, ubs: ubs, patient_id: nil).first

      appointment.update!(
        patient_id: patient.id,
        second_dose: patient.appointments.order(:start).select(&:active?).last&.check_out.present?,
        vaccine_name: patient.appointments.order(:start).select(&:active?).last&.vaccine_name
      )

      patient.update!(last_appointment: appointment)

      [:success, appointment]
    end
  rescue => e
    Sentry.capture_exception(e)

    [:internal_error, e.message]
  end
end
