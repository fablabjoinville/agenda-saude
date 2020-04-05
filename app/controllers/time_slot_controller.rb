class TimeSlotController < PatientSessionController
  def schedule
    @ubs = Ubs.find(schedule_params[:ubs_id])
    start_time = Time.parse(schedule_params[:start_time])

    @appointment = Appointment.create(
      patient: current_patient,
      ubs: @ubs,
      start: start_time,
      end: start_time + @ubs.slot_interval,
      active: true
    )

    return render json: @appointment.errors unless @appointment.save

    render 'patient/successfull_schedule'
  end

  def index
    @time_slots = Ubs.all.each_with_object({}) do |ubs, memo|
      memo[ubs] = ubs.available_time_slots(Date.today...3.days.from_now)
    end
  end

  private

  def schedule_params
    params.permit(:start_time, :ubs_id)
  end
end
