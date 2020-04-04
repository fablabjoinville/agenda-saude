# frozen_string_literal: true

class Patients::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    puts params
    @cpf = login_params[:cpf]

    super
  end

  # POST /resource/sign_in
  def create
    patient = Patient.find_by(cpf: login_params[:cpf])

    return sign_in(patient, scope: :patient) if login_params[:password] == patient.mother_name

    render json: { got: patient.password, }
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:cpf, :password])
  end

  def login_params
    params.require(:patient).permit(:cpf, :password)
  end
end
