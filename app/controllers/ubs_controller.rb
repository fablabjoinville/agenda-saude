class UbsController < UserSessionController
  before_action :set_ubs

  def active_hours
    @appointments = active_future_appointments
  end

  def index
    @appointments = future_appointments.order(start: :asc)
    @bedridden_patients = @ubs.bedridden_patients
  end

  def activate_ubs
    updated = @ubs.update(active: true)

    return redirect_to ubs_index_path if updated
  end

  def deactivate_ubs
    updated = @ubs.update(active: false)

    return redirect_to ubs_index_path if updated
  end

  def change_active_hours
    shift_start_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_start_date'))
    break_start_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_start_date'))
    break_end_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_end_date'))
    shift_end_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_end_date'))

    shift_start_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_start_saturday'))
    break_start_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_start_saturday'))
    break_end_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_end_saturday'))
    shift_end_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_end_saturday'))

    open_on_saturday = active_hours_params['open_saturday'].to_i == 1

    updated = @ubs.update(
                  shift_start: shift_start_tod.to_s,
                  break_start: break_start_tod.to_s,
                  break_end: break_end_tod.to_s,
                  shift_end: shift_end_tod.to_s,
                  open_saturday: open_on_saturday,
                  saturday_shift_start: shift_start_sat_tod.to_s,
                  saturday_break_start: break_start_sat_tod.to_s,
                  saturday_break_end: break_end_sat_tod.to_s,
                  saturday_shift_end: shift_end_sat_tod.to_s
                )

    return redirect_to ubs_index_path if updated

    render ubs_active_hours_path
  end

  def slot_duration
    @appointments = active_future_appointments
  end

  def change_slot_duration
    updated = @ubs.update(slot_duration_params)

    return redirect_to ubs_index_path if updated

    render ubs_slot_duration_path
  end

  def cancel_appointment
    appointment = @ubs.appointments.find(params[:id])

    appointment.update(active: false)

    redirect_to ubs_index_path
  end

  def activate_appointment
    appointment = @ubs.appointments.find(params[:id])

    appointment.update(active: true)

    redirect_to ubs_index_path
  end

  def cancel_all_future_appointments
    appointments = future_appointments

    appointments.update_all(active: false)

    redirect_to ubs_index_path
  end

  def activate_all_future_appointments
    appointments = @ubs.appointments.where(
      'start >= ? AND active = ?', Time.zone.now - @ubs.slot_interval_minutes * 60, false
    )

    appointments.update_all(active: true)

    redirect_to ubs_index_path
  end

  private

  def active_future_appointments
    @future_appointments = @ubs.appointments.where(
      'start >= ? AND active = ?', Time.zone.now, true
    )
  end

  def future_appointments
    @future_appointments = @ubs.appointments.where(
      'start >= ?', Time.zone.now - @ubs.slot_interval_minutes * 60
    )
  end

  def active_hour_for_attr(attr_name)
    "#{active_hours_params[attr_name + '(4i)']}:#{active_hours_params[attr_name + '(5i)']}"
  end

  def set_ubs
    @ubs = Ubs.find_by(user: current_user)
  end

  def active_hours_params
    params.require(:ubs).permit(:shift_start_date, :shift_end_date, :break_start_date, :break_end_date,
    :shift_start_saturday, :break_start_saturday, :break_end_saturday, :shift_end_saturday, :open_saturday)
  end

  def slot_duration_params
    params.require(:ubs).permit(:slot_interval_minutes)
  end
end
