class ApplicationController < ActionController::Base
  helper_method :current_patient

  protected

  def current_patient
    return if session[:patient_id].blank?

    @current_patient = Patient.find session[:patient_id]
  end

  def date_from_params(params, date_key)
    date_keys = params.keys.select { |k| k.to_s.match?(date_key.to_s) }.sort
    return nil if date_keys.empty?

    date_array = params.values_at(*date_keys).map(&:to_i)
    Date.civil(*date_array)
  end
end
