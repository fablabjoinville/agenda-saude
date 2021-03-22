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
    return [:invalid_schedule_time] if start_time > (Time.zone.now + @max_schedule_time_ahead).at_end_of_day

    Appointment.transaction(isolation: :repeatable_read) do
      patient.reload

      return [:schedule_conditions_unmet] unless patient.can_schedule?

      appointment = Appointment.where(start: start_time, ubs_id: ubs.id, patient_id: nil)
        .order('random()') # reduces row lock contention
        .first

      return [:all_slots_taken] unless appointment.present?

      patient.appointments.futures.update_all(patient_id: nil)

      appointment.update!(
        patient_id: patient.id,
        second_dose: patient.current_appointment&.check_out.present?,
        vaccine_name: patient.current_appointment&.vaccine_name
      )

      # TODO: remove this after we get rid of last_appointment
      patient.update!(last_appointment: appointment)

      [:success, appointment]
    end
  rescue ActiveRecord::SerializationFailure
    [:all_slots_taken]
  rescue => e
    Sentry.capture_exception(e)

    [:internal_error, e.message]
  end
end
