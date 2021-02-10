class AdminController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    number_days = date_range_params[:date_period].to_i || 0
    
    if number_days == 7
      @period_text = "Últimos 7 dias"
    elsif number_days == 30
      @period_text = "Últimos 30 dias"
    else
      number_days = 0
      @period_text = "Hoje"
    end
    
    start_period = (Time.zone.now-number_days.days).beginning_of_day
    end_period = Time.zone.now.end_of_day
    appointments_by_period = Appointment.where(start: start_period..end_period, active: true)

    @appointments_all = appointments_by_period.count
    @appointments_occupied = appointments_by_period.where.not(patient_id: nil).count
    @appointments_with_checkin = appointments_by_period.where.not(check_in: nil).count
    @appointments_without_checkin = appointments_by_period.where(check_in: nil).count
    @appointments_with_checkout = appointments_by_period.where.not(check_out: nil).count

    @patients_registred = Patient.where(created_at: start_period..end_period).count
  end

  private

  def date_range_params
    params.permit(:date_period)
  end
end
