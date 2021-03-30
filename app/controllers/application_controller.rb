class ApplicationController < ActionController::Base
  helper_method :current_patient

  protected

  def current_patient
    return if session[:patient_id].blank?

    @current_patient = Patient.find session[:patient_id]
  end
end
