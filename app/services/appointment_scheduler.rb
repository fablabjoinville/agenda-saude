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
    return [:schedule_conditions_unmet] unless patient.can_schedule?

    future_appointment = patient.appointments.future.current

    # Single SQL query to update the first available record it can find
    # it will either return 0 if no rows could be found, or 1 if it was able to schedule an appointment
    rows_updated = Appointment.
      where(start: start_time, ubs_id: ubs, patient_id: nil).
      limit(1).
      update_all(patient_id: patient.id)

    return [:all_slots_taken] if rows_updated.zero?

    new_appointment = patient.appointments.where.not(id: future_appointment&.id).find_by!(ubs: ubs, start: start_time)
    if future_appointment
      # Update new appointment with data from current
      new_appointment.update!(
        second_dose: future_appointment.second_dose,
        vaccine_name: future_appointment.vaccine_name
      )

      # Free up future appointment
      future_appointment.update!(patient: nil)
    end

    [:success, new_appointment]
  rescue => e
    ExceptionNotifierService.(e)

    [:internal_error, e.message]
  end
end
