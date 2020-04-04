class HomeController < ApplicationController
  def index; end

  def patient_base_login
    cpf = base_login_params[:cpf]
    return render json: {}, status: :bad_request unless CPF.valid?(cpf)

    return redirect_to new_patient_session_path(patient: { cpf: cpf }) if Patient.find_by_cpf(cpf)

    redirect_to new_patient_registration_path(cpf: cpf)
  end

  private

  def base_login_params
    params.require(:patient).permit(:cpf)
  end
end
