class ApplicationController < ActionController::Base
  helper_method :current_patient, :return_to

  protected

  def current_patient
    return if session[:patient_id].blank?

    @current_patient ||= Patient.find session[:patient_id]
  end

  def date_from_params(params, date_key)
    date_keys = params.keys.select { |k| k.to_s.match?(date_key.to_s) }.sort
    return nil if date_keys.empty?

    date_array = params.values_at(*date_keys).map(&:to_i)
    Date.civil(*date_array)
  end

  def return_to
    return nil unless allowed_host?(params[:return_to])

    params[:return_to].presence
  end

  def allowed_host?(url)
    URI(url.to_s).host == request.host
  rescue ArgumentError, URI::Error
    false
  end
end
