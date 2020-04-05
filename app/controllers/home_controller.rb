class HomeController < ApplicationController
  def index
    return redirect_to index_time_slot_path if current_patient
    return redirect_to ubs_index_path if current_user
  end

  def patient_base_login
    cpf = base_login_params[:cpf]
    return render json: {}, status: :bad_request unless CPF.valid?(cpf)

    return redirect_to new_patient_session_path(patient: { cpf: cpf }) if Patient.find_by_cpf(cpf)

    redirect_to new_patient_registration_path(cpf: cpf)
  end

  def unblock
    patient = Patient.find_by(cpf: unblock_params[:cpf])

    patient.unblock!

    render html: "<h1>#{patient.name.titleize} desbloqueado!</h1>".html_safe
  end

  private

  def base_login_params
    params.require(:patient).permit(:cpf)
  end

  def unblock_params
    params.permit(:cpf)
  end
end
