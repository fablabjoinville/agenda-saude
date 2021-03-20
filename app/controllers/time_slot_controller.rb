require_relative './../helpers/time_slot_helper'
# include TimeSlotHelper

class TimeSlotController < PatientSessionController
  before_action :render_patient_not_allowed

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 3

  def schedule
    @ubs = Ubs.find(schedule_params[:ubs_id])
    start_time = Time.parse(schedule_params[:start_time])

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
    @ubs = @appointment.try(:ubs)

    @patient_can_schedule = current_patient.can_schedule?

    return render_vaccinated if current_patient.vaccinated?

    @gap_in_days = slot_params[:gap_in_days].to_i || 0
    @current_day = Time.zone.now + @gap_in_days.days

    @group_time_slots = {}

    last_appointment = current_patient.last_appointment
    return if last_appointment&.second_dose? && @current_day.to_date < last_appointment.start.to_date

    if @gap_in_days <= TimeSlotController::SLOTS_WINDOW_IN_DAYS && @gap_in_days >= 0
      if @current_day.today?
        group_ubs_appointments = ubs_appointments_available(current_patient, @current_day, @current_day.end_of_day)
      else
        group_ubs_appointments = ubs_appointments_available(current_patient, @current_day.at_beginning_of_day, @current_day.end_of_day)
      end

      group_ubs_appointments.each do |group_desc, ubs_appointments|
        time_slots = {}
        ubs_appointments.each do |ubs_id, appointments|
          ubs = Ubs.find(ubs_id)
          next unless ubs.active

          slots = []
          appointments.each do |appointment|
            slots << { slot_start: appointment.start, slot_end: appointment.end, group_name: appointment.group&.name || "População em geral", min_age: appointment.min_age, commorbidity: appointment.commorbidity }
          end
          time_slots[ubs] = slots.uniq
        end
        @group_time_slots[group_desc] = time_slots
      end
      @group_time_slots
    end
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
    return render 'patients/not_allowed' unless current_patient.can_see_appointment? || current_patient.can_schedule?
  end

  def render_vaccinated
    @first_appointment = current_patient.first_appointment

    render 'patients/vaccineted'
  end

  def ubs_appointments_available(patient, start_time, end_time)
    appointments_available = Appointment.where(start: start_time..end_time, patient_id: nil, active: true)
    return {} unless appointments_available.exists?

    groups_available = appointments_available.pluck(:group_id, :min_age, :commorbidity, :ubs_id).uniq
    
    group_ubs_appointments = {}
    
    groups_available.each do |group_age_comorbidity|
      group_id = group_age_comorbidity[0]
      min_age = group_age_comorbidity[1]
      comorbidity = group_age_comorbidity[2]
      ubs = group_age_comorbidity[3]
      
      ubs_appointments_available = {}
      if group_id == nil && min_age > 0 && comorbidity == false
        if current_patient.age >= min_age
          groups_description = "População em geral com #{min_age} anos ou mais"
          appointments = appointments_available.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs)
        end
      elsif group_id == nil && min_age > 0 && comorbidity == true
        if current_patient.age >= min_age && current_patient.groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
          groups_description = "População em geral com #{min_age} anos ou mais que tenha alguma comorbidade"
          appointments = appointments_available.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs)
        end
      elsif group_id != nil && min_age > 0 && comorbidity == false
        if current_patient.age >= min_age && current_patient.groups.include?(Group.find(group_id))
          groups_description = "#{Group.find(group_id).name} com #{min_age} anos ou mais"
          appointments = appointments_available.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs)
        end
      elsif group_id != nil && min_age > 0 && comorbidity == true
        if current_patient.age >= min_age && current_patient.groups.include?(Group.find(group_id)) && current_patient.groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
          groups_description = "#{Group.find(group_id).name} com #{min_age} anos ou mais que tenha alguma comorbidade"
          appointments = appointments_available.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs)
        end
      end

      next if appointments.nil?

      ubs_appointments_available[ubs] = appointments
      group_ubs_appointments[groups_description] = ubs_appointments_available
    end
    group_ubs_appointments
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
end
