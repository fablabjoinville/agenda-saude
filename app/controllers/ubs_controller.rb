class UbsController < UserSessionController
  before_action :set_ubs

  def active_hours; end

  def change_active_hours
    shift_start_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_start_date'))
    break_start_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_start_date'))
    break_end_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_end_date'))
    shift_end_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_end_date'))

    updated = @ubs.update(
                  shift_start: shift_start_tod.to_s,
                  break_start: break_start_tod.to_s,
                  break_end: break_end_tod.to_s,
                  shift_end: shift_end_tod.to_s
                )

    return redirect_to ubs_active_hours_path if updated

    render ubs_active_hours_path
  end

  def change_slot_duration
  end

  private

  def active_hour_for_attr(attr_name)
    "#{active_hours_params[attr_name + '(4i)']}:#{active_hours_params[attr_name + '(5i)']}"
  end

  def set_ubs
    @ubs = Ubs.find_by(user: current_user)
  end

  def active_hours_params
    params.require(:ubs).permit(:shift_start_date, :shift_end_date, :break_start_date, :break_end_date)
  end

  def slot_duration_params
    params.require(:ubs).permit(:slot_duration_minutes)
  end
end
