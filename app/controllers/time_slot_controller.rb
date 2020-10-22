require_relative './../helpers/time_slot_helper'
# include TimeSlotHelper

class TimeSlotController < PatientSessionController

  SLOTS_WINDOW_IN_DAYS = 30

  def schedule
    @ubs = Ubs.find(schedule_params[:ubs_id])
    start_time = Time.parse(schedule_params[:start_time])

    Appointment.transaction do
      if Appointment.where(start: start_time, ubs: @ubs).present?
        flash[:notice] = 'Opa! O horário foi reservado enquanto você escolhia, tente outro!'
        redirect_to time_slot_path

        return
      end

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
    # FIXME We need to change this relation to has_one or enhance the logic here
    @appointment = current_patient.appointments.last
    @ubs = @appointment.try(:ubs)

    @gap_in_days = params[:gap_in_days].to_i || 0
    @current_day = Time.zone.now + @gap_in_days.days

    @gap_in_days > TimeSlotController::SLOTS_WINDOW_IN_DAYS

    @time_slots = []
    if !@current_day.past? && !@current_day.sunday? && !(@gap_in_days > TimeSlotController::SLOTS_WINDOW_IN_DAYS)
      @time_slots = Ubs.all.where(active: true).each_with_object({}) do |ubs, memo|
        next unless ubs.business_day?(@current_day, ubs.open_saturday?)

        slots = {}
        slots[@current_day] = ubs.available_time_slots_for_day(@current_day, Time.zone.now)
        slots.delete(@current_day) if slots[@current_day].empty?

        memo[ubs] = slots

        # TODO: Refactor to not include these as available
        memo.delete(ubs) if memo[ubs].empty?
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
