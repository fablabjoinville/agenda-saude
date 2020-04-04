# frozen_string_literal: true

class Patients::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    cpf = CPF.new(cpf_params[:cpf])

    if cpf.valid?
      return render json: 'CADASTRADO -> Pedir nome da mãe' if Patient.find_by_cpf(cpf.formatted)
      redirect_to new_patient_registration_path
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def cpf_params
    params.require(:patient).permit(:cpf)
  end
end
