class TimeSlotController < PatientSessionController
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

    return render json: @appointment.errors unless @appointment.save

    render 'patients/successfull_schedule'
  end

  def cancel
    @appointment = Appointment.find(cancel_params[:appointment_id])

    @appointment.destroy

    redirect_to time_slot_path
  end

  def index
    # FIXME We need to change this relation to has_one or enhance the logic here
    @appointment = current_patient.appointments.last
    @ubs = @appointment.try(:ubs)

    @time_slots = Ubs.all.where(active: true).each_with_object({}) do |ubs, memo|
      memo[ubs] = ubs.available_time_slots(4)
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
