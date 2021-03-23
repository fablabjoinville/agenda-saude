class HomeController < ApplicationController

  def index
    return redirect_to index_bedridden_path if current_patient.try(:bedridden?)
    return redirect_to index_time_slot_path if current_patient
    return redirect_to list_checkin_path if current_user

    from = Time.zone.now
    to = (from + Appointment::SLOTS_WINDOW_IN_DAYS.days).end_of_day
    @available_time_slots_count = Appointment.free.start_between(from, to).count
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
end
