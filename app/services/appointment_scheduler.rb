class AppointmentScheduler
  CONDITIONS_UNMET = :conditions_unmet
  NO_SLOTS = :no_slots
  SUCCESS = :success

  def schedule(patient:, ubs_id:, start:)
    return [CONDITIONS_UNMET] unless patient.can_schedule?

    current_appointment = patient.appointments.current

    Appointment.transaction(isolation: :repeatable_read) do
      success = update_appointment(
        patient_id: patient.id,
        ubs_id: ubs_id,
        start: start
      )
      return [NO_SLOTS] unless success

      new_appointment = patient.appointments.open.where.not(id: current_appointment&.id).first!
      if current_appointment
        # Update new appointment with data from current
        new_appointment.update!(
          vaccine_name: current_appointment.vaccine_name
        )

        # Free up current appointment if it wasn't checkout out (completed)
        unless current_appointment.checked_out?
          current_appointment.update!(patient: nil, check_in: nil, check_out: nil, second_dose: nil, vaccine_name: nil)
        end
      end

      [SUCCESS, new_appointment]
    end
  end

  def update_appointment(patient_id:, start:, ubs_id:)
    # Single SQL query to update the first available record it can find
    # it will either return 0 if no rows could be found, or 1 if it was able to schedule an appointment
    appointment = Appointment
                  .active_ubs
                  .open
                  .not_scheduled
                  .order(:start)
                  .where(start: start)
                  .limit(1)

    appointment = appointment.where(ubs_id: ubs_id) if ubs_id.present?

    appointment
      .update_all(patient_id: patient_id)
      .positive? # 0 = false, 1 = true
  end
end
