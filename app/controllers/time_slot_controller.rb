require_relative './../helpers/time_slot_helper'
# include TimeSlotHelper

class TimeSlotController < PatientSessionController

  SLOTS_WINDOW_IN_DAYS = 10

  def schedule
    @ubs = Ubs.find(schedule_params[:ubs_id])
    start_time = Time.parse(schedule_params[:start_time])

    Appointment.transaction do
      if Appointment.where(start: start_time, ubs: @ubs).present?
        flash[:alert] = 'Opa! O horário foi reservado enquanto você escolhia, tente outro!'
        redirect_to time_slot_path

        return
      end

      current_patient.appointments.futures.destroy_all

      @appointment = Appointment.create(
        patient: current_patient,
        ubs: @ubs,
        start: start_time,
        end: start_time + @ubs.slot_interval,
        active: true
      )
    end

    @patient = Patient.find(current_patient.id)
    @patient.last_appointment = start_time
    @patient.save

    return render json: @appointment.errors unless @appointment.save

    render 'patients/successfull_schedule'
  end

  def cancel
    @appointment = Appointment.find(cancel_params[:appointment_id])
    @appointment.destroy

    @patient = Patient.find(current_patient.id)
    @patient.last_appointment = nil
    @patient.save

    redirect_to time_slot_path
  end

  def index
    @appointment = current_patient.current_appointment
    @ubs = @appointment.try(:ubs)

    @gap_in_days = slot_params[:gap_in_days].to_i || 0
    @current_day = Time.zone.now + @gap_in_days.days

    @time_slots = {}
    unless @gap_in_days < 0 || @current_day.sunday? || @gap_in_days > TimeSlotController::SLOTS_WINDOW_IN_DAYS
      @time_slots = Ubs.where(active: true).each_with_object({}) do |ubs, memo|
        next unless ubs.business_day?(@current_day, ubs.open_saturday?)

        day_slots = ubs.available_time_slots_for_day(@current_day, Time.zone.now)
        memo[ubs] = day_slots if day_slots.any?
      end
    end
  end

  private

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
