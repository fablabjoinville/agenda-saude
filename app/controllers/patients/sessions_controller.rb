# frozen_string_literal: true

class Patients::SessionsController < Devise::SessionsController
  # GET /patient/sign_in
  def new
    unless patient.fake_mothers.present?
      mother_list = MotherNameService.name_list(patient.mother_name)
      patient.update!(fake_mothers: mother_list)
    end

    @mother_list = patient.fake_mothers
    super
  rescue ActionController::ParameterMissing
    redirect_to '/'
  end

  # POST /patient/sign_in
  def create
    return render 'patient/blocked' if patient.blocked?
    return patient_sign_in if mother_name_matches?

    patient.increase_login_attempts

    return render 'patient/blocked' if patient.blocked?

    render 'patient/login_failed'
  end

  # DELETE /patient/sign_out
  # def destroy
  #   super
  # end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:cpf, :password])
  end

  private

  def patient
    @patient ||= Patient.find_by(cpf: login_params[:cpf])
  end

  def login_params
    params.require(:patient).permit(:cpf, :password)
  end

  def mother_name_matches?
    processed_mother_name = MotherNameService.process_name(patient.mother_name)

    login_params[:password] == processed_mother_name
  end

  def patient_sign_in
    sign_in(patient, scope: :patient)

    patient.update!(fake_mothers: [], login_attempts: 0)

    redirect_to time_slot_path
  end
end
