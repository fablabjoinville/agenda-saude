require_relative './../helpers/time_slot_helper'
# include TimeSlotHelper

class TimeSlotController < PatientSessionController

  before_action :render_patient_not_allowed

  SLOTS_WINDOW_IN_DAYS = 3

  def schedule
    @ubs = Ubs.find(schedule_params[:ubs_id])
    start_time = Time.parse(schedule_params[:start_time])

    @patient = Patient.find(current_patient.id)
    return render 'patients/not_allowed' unless @patient.can_schedule?

    Appointment.transaction do
      unless Appointment.where(start: start_time, ubs: @ubs, patient_id: nil).exists?
        flash[:alert] = 'Opa! O horário foi reservado enquanto você escolhia, tente outro!'
        redirect_to time_slot_path

        return
      end

      Appointment.where(patient_id: current_patient.id).futures.each do |appointment|
        appointment.update(patient_id: nil)
      end

      @appointment = Appointment.where(start: start_time, ubs: @ubs, patient_id: nil).first

      return render json: @appointment.errors unless @appointment.update!(patient_id: current_patient.id)
    end

    @current_patient.update(last_appointment: @appointment)

    render 'patients/successfull_schedule'
  end

  def cancel
    @appointment = Appointment.find(cancel_params[:appointment_id])
    @appointment.update(patient_id: nil)

    @current_patient.update(last_appointment: nil)

    redirect_to time_slot_path
  end

  def index
    @appointment = current_patient.current_appointment
    @ubs = @appointment.try(:ubs)

    @gap_in_days = slot_params[:gap_in_days].to_i || 0
    @current_day = Time.zone.now + @gap_in_days.days

    @time_slots = {}

    last_appointment = current_patient.last_appointment
    return if last_appointment&.second_dose? && @current_day.to_date < last_appointment.start.to_date

    Ubs.where(active: true).each do |ubs|
      slots = []

      if @gap_in_days <= TimeSlotController::SLOTS_WINDOW_IN_DAYS && @gap_in_days >= 0
        if @current_day.today?
          appointments = Appointment.where(start: @current_day..@current_day.end_of_day, ubs: ubs, patient_id: nil)
        else
          appointments = Appointment.where(start: @current_day.at_beginning_of_day..@current_day.end_of_day, ubs: ubs, patient_id: nil)
        end

        next unless appointments.exists?

        appointments.each do |appointment|
          slots << { slot_start: appointment.start, slot_end: appointment.end }
        end

        @time_slots[ubs] = slots.uniq
      end
    end
  end

  private

  def render_patient_not_allowed
    return render 'patients/not_allowed' unless current_patient.can_schedule?
  end

  def slot_params
    params.permit(:gap_in_days)
  end

  def schedule_params
    params.permit(:start_time, :ubs_id)
  end

  def cancel_params
    params.permit(:appointment_id)
  end
end
