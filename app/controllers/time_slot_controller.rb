require_relative './../helpers/time_slot_helper'
include TimeSlotHelper

class TimeSlotController < PatientSessionController

  SLOTS_WINDOW_IN_DAYS = 4

  def schedule
    @ubs = Ubs.find(schedule_params[:ubs_id])
    start_time = Time.parse(schedule_params[:start_time])

    Appointment.transaction do
      if Appointment.where(start: start_time, ubs: @ubs).present?
        flash[:notice] = 'Opa! O horário foi reservado enquanto você escolhia, tente outro!'
        redirect_to time_slot_path

        return
      end

      current_patient.appointments.destroy_all

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

    date_range = build_weekdays_date_range(TimeSlotController::SLOTS_WINDOW_IN_DAYS)

    @time_slots = Ubs.all.where(active: true).each_with_object({}) do |ubs, memo|
      memo[ubs] = ubs.available_time_slots(date_range, Time.zone.now)
      # TODO: Refactor to not include these as available
      memo.delete(ubs) if memo[ubs].empty?
    end
  end

  private

  def schedule_params
    params.permit(:start_time, :ubs_id)
  end

  def cancel_params
    params.permit(:appointment_id)
  end
end
