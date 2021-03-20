class HomeController < ApplicationController
  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 3
  
  def index
    return redirect_to index_bedridden_path if current_patient.try(:bedridden?)
    return redirect_to index_time_slot_path if current_patient
    return redirect_to list_checkin_path if current_user

    @ubs_conditions = ubs_conditions_available()

    @is_scheduling_available = Appointment.free.within_allowed_window.exists?
  end

  def patient_base_login
    cpf = base_login_params[:cpf]

    unless CPF.valid?(cpf)
      flash[:alert] = 'CPF Inválido'
      redirect_to '/'
      return
    end

    return redirect_to new_patient_session_path(patient: { cpf: cpf }) if Patient.find_by(cpf: cpf)

    redirect_to new_patient_registration_path(cpf: cpf)
  end

  def unblock
    patient = Patient.find_by(cpf: unblock_params[:cpf])

    if patient
      patient.unblock!

      render html: "<h1>#{patient.name.titleize} desbloqueado!</h1>".html_safe
    else
      render html: '<h1>Paciente não encontrado</h1>'.html_safe
    end
  end

  def register_patient
    cpf = register_patient_params[:cpf]

    unless CPF.valid?(cpf)
      flash[:notice] = 'CPF Inválido'
      redirect_to '/'
      return
    end

    return redirect_to new_patient_session_path(patient: { cpf: cpf }) if Patient.find_by(cpf: cpf)

    redirect_to new_patient_registration_path(cpf: cpf)
  end

  private

  def base_login_params
    params.require(:patient).permit(:cpf)
  end

  def unblock_params
    params.permit(:cpf)
  end

  def register_patient_params
    params.permit(:cpf)
  end

  def ubs_conditions_available
    conditions = {}

    schedule_start_time = Time.zone.now
    schedule_end_time = (schedule_start_time + SLOTS_WINDOW_IN_DAYS.days).end_of_day

    ubs_groups = ubs_schedule_groups_available(schedule_start_time, schedule_end_time)

    if ubs_groups.blank?
      conditions["Sem vagas"] = ["Nenhum agendamento disponivel no momento"]
      return conditions
    end

    ubs_groups.each do |ubs, groups|
      ubs_name = ubs.name
      groups_description = []
      groups.each do |group|
        group_id = group[0]
        min_age = group[1]
        comorbidity = group[2]
        if group_id == nil && min_age > 0 && comorbidity == false
          groups_description << "População em geral com #{min_age} anos ou mais"
        elsif group_id == nil && min_age > 0 && comorbidity == true
          groups_description << "População em geral com #{min_age} anos ou mais que tenha alguma comorbidade"
        elsif group_id != nil && min_age > 0 && comorbidity == false
          groups_description << "#{Group.find(group_id).name} com #{min_age} anos ou mais"
        elsif group_id != nil && min_age > 0 && comorbidity == true
          groups_description << "#{Group.find(group_id).name} com #{min_age} anos ou mais que tenha alguma comorbidade"
        end
      end
      conditions[ubs_name] = groups_description
    end
    conditions
  end

  def ubs_schedule_groups_available(start_time, end_time)
    groups_available = {}
    Ubs.where(active: true).each do |ubs|
      appointments_available = Appointment.where(start: start_time..end_time, patient_id: nil, active: true, ubs: ubs).select([:id, :ubs_id, :group_id, :min_age, :commorbidity])
      next unless appointments_available.exists?
        groups_available[ubs] = appointments_available.pluck(:group_id, :min_age, :commorbidity).uniq
    end
    groups_available
  end
end
