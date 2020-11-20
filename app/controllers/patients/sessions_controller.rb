# frozen_string_literal: true

class Patients::SessionsController < Devise::SessionsController
  after_action :ignore_flash

  # GET /patient/sign_in
  def new
    unless patient.fake_mothers.present?
      mother_list = MotherNameService.name_list(patient.mother_name)
      patient.update!(fake_mothers: mother_list)
    end

    # Verifica se o paciente fez agendamento em menos de DAYS_FOR_NEW_APPOINTMENT dias
    # return render 'patients/appoitment_blocked' if patient.wait_appointment_time?

    @mother_list = patient.fake_mothers
    super
  rescue ActionController::ParameterMissing
    redirect_to '/'
  end

  # POST /patient/sign_in
  def create
    return render 'patients/blocked' if patient.blocked?
    return patient_sign_in if mother_name_matches?

    patient.increase_login_attempts

    return render 'patients/blocked' if patient.blocked?

    render 'patients/login_failed'
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

  def ignore_flash
    flash.delete(:notice)
  end

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

    return redirect_to index_bedridden_path if patient.bedridden?

    # return render 'patients/not_allowed' unless patient.allowed_age?

    redirect_to time_slot_path
  end
end
