class AppointmentScheduler
  def initialize(max_schedule_time_ahead:)
    @max_schedule_time_ahead = if max_schedule_time_ahead.is_a?(ActiveSupport::Duration)
                                 max_schedule_time_ahead
                               else
                                 max_schedule_time_ahead.days
                               end
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def schedule(raw_start_time:, ubs:, patient:)
    start_time = Time.parse(raw_start_time)

    return [:inactive_ubs] unless ubs.active?
    return [:invalid_schedule_time] if start_time > (Time.zone.now + @max_schedule_time_ahead).at_end_of_day
    return [:schedule_conditions_unmet] unless patient.can_schedule?

    new_appointment = nil
    current_appointment = patient.appointments.current

    Appointment.transaction(isolation: :repeatable_read) do
      # Single SQL query to update the first available record it can find
      # it will either return 0 if no rows could be found, or 1 if it was able to schedule an appointment
      rows_updated = Appointment
                     .where(start: (start_time - 1.minute)..(start_time + 1.minute), ubs_id: ubs, patient_id: nil)
                     .limit(1)
                     .update_all(patient_id: patient.id)

      return [:all_slots_taken] if rows_updated.zero?

      new_appointment = patient.appointments.where.not(id: current_appointment&.id).find_by!(ubs: ubs, start: start_time)
      if current_appointment
        # Update new appointment with data from current
        new_appointment.update!(
          second_dose: current_appointment.second_dose,
          vaccine_name: current_appointment.vaccine_name
        )

        # Free up current appointment if it wasn't checkout out (completed)
        unless current_appointment.checked_out?
          current_appointment.update!(patient: nil, check_in: nil, check_out: nil, second_dose: nil, vaccine_name: nil)
        end
      end
    end

    [:success, new_appointment]
  rescue StandardError => e
    ExceptionNotifierService.call(e)

    [:internal_error, e.message]
  end
  # rubocop:enable Metrics/PerceivedComplexity
end
