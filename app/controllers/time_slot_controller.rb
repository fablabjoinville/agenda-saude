require_relative './../helpers/time_slot_helper'
# include TimeSlotHelper

class TimeSlotController < PatientSessionController
  before_action :render_patient_not_allowed

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 7

  def schedule
    @ubs = Ubs.find(schedule_params[:ubs_id])

    result, data = appointment_scheduler.schedule(
      raw_start_time: schedule_params[:start_time],
      ubs: @ubs,
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
      render 'patients/successfull_schedule'
    else
      notify_unexpected_result(result: result, data: data, context: context)
      render_error_in_time_slots_page('Ocorreu um erro. Por favor, tente novamente.')
    end
  end

  def cancel
    Appointment.transaction do
      @current_patient.appointments
        .where(id: cancel_params[:appointment_id])
        .update_all(patient_id: nil)

      @current_patient.update(last_appointment: nil)
    end

    redirect_to time_slot_path
  end

  def index
    @appointment = current_patient.current_appointment
    @patient_can_schedule = current_patient.can_schedule?
    return render_vaccinated if current_patient.vaccinated?

    @gap_in_days = gap_in_days
    @current_day = [Time.zone.now.at_beginning_of_day + @gap_in_days.days, Time.zone.now].max # prevent users from scheduling in the past

    last_appointment = current_patient.last_appointment
    return if last_appointment&.second_dose? && @current_day.to_date < last_appointment.start.to_date

    @time_slots = Appointment.
      includes(:ubs).
      free. # can be scheduled
      start_between(@current_day, @current_day.end_of_day). # in the date the user is looking for
      order(:start). # in chronological order
      select(:ubs_id, :start, :end). # only return what we care with
      distinct. # remove duplicates (same as .uniq in pure Ruby)
      group_by { |a| a.ubs } # transforms it into a Hash grouped by Ubs
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
    @first_appointment = current_patient.first_appointment

    render 'patients/vaccineted'
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
