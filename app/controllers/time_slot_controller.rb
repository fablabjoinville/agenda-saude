class TimeSlotController < PatientSessionController
  before_action :render_patient_not_allowed

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 7

  def schedule
    ubs = Ubs.find(schedule_params[:ubs_id])

    result, data = appointment_scheduler.schedule(
      raw_start_time: schedule_params[:start_time],
      ubs: ubs,
      patient: current_patient
    )

    case result
    when :inactive_ubs
      render_error_in_time_slots_page(
        'Unidade de atendimento desativada. Tente novamente mais tarde.'
      )
    when :schedule_conditions_unmet
      render 'patients/not_allowed'
    when :invalid_schedule_time
      notify_invalid_schedule_attempt
      render_error_in_time_slots_page('Data de agendamento inválida.')
    when :all_slots_taken
      render_error_in_time_slots_page(
        'Opa! O horário foi reservado enquanto você escolhia, tente outro!'
      )
    when :success
      @appointment = data
      render 'patients/successful_schedule'
    else
      notify_unexpected_result(result: result, data: data, context: context)
      render_error_in_time_slots_page('Ocorreu um erro. Por favor, tente novamente.')
    end
  end

  def cancel
    @current_patient.appointments
                    .where(id: cancel_params[:appointment_id])
                    .update_all(patient_id: nil)

    redirect_to time_slot_path
  end

  def index
    @appointment = current_patient.appointments.future.current
    @patient_can_schedule = current_patient.can_schedule?
    return render_vaccinated if current_patient.vaccinated?

    @gap_in_days = gap_in_days

    # prevent users from scheduling in the past:
    @current_day = [Time.zone.now.at_beginning_of_day + @gap_in_days.days, Time.zone.now].max

    # TODO: commented out this line while we don't have patient with second dose (at least not many), to save SQL
    # resources. Consider how to optimize it.
    # The intention here is that, after a patient had the 2nd dose, they shouldn't be able to schedule new appointments
    # if current_patient.appointments.current&.second_dose? &&
    #    @current_day.to_date < current_patient.appointments.current&.start.to_date
    #   return
    # end

    @time_slots = Appointment
                  .includes(:ubs)
                  .free # can be scheduled
                  .start_between(@current_day, @current_day.end_of_day) # in the date the user is looking for
                  .order(:start) # in chronological order
                  .select(:ubs_id, :start, :end) # only return what we care with
                  .distinct # remove duplicates (same as .uniq in pure Ruby)
                  .group_by(&:ubs) # transforms it into a Hash grouped by Ubs
  end

  private

  def render_error_in_time_slots_page(message)
    flash[:alert] = message
    redirect_to time_slot_path
  end

  def context
    params.merge(patient_id: current_patient.id)
  end

  def notify_invalid_schedule_attempt
    SlackNotifier.warn(
      "Tentativa de agendamento fora da janela permitida.\n" \
      "Contexto: `#{context.to_json}`"
    )
  end

  def notify_unexpected_result(data)
    SlackNotifier.warn(
      "Agendamento com resultado inesperado! Dados: `#{data.to_json}`"
    )
  end

  def appointment_scheduler
    @appointment_scheduler ||= AppointmentScheduler.new(
      max_schedule_time_ahead: SLOTS_WINDOW_IN_DAYS
    )
  end

  def render_patient_not_allowed
    return render 'patients/not_allowed' unless current_patient.allowed?
  end

  def render_vaccinated
    # TODO: improve how we load current and first appointments
    @appointment = current_patient.appointments.current
    @first_appointment = current_patient.first_appointment

    render 'patients/vaccinated'
  end

  def slot_params
    params.permit(:gap_in_days)
  end

  def schedule_params
    params.permit(:start_time, :ubs_id)
  end

  def cancel_params
    params.permit(:appointment_id)
  end

  # Ensure that only valid integers are returned from param (from 0 to the one set on the constant)
  def gap_in_days
    [
      [
        slot_params[:gap_in_days]&.to_i || 0,
        0
      ].max,
      TimeSlotController::SLOTS_WINDOW_IN_DAYS
    ].min
  end
end
