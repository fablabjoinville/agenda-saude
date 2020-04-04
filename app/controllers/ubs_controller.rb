class UbsController < UserSessionController
  before_action :set_ubs

  def active_hours
    respond_to do |t|
      t.html  { }
      t.json do
        shift_start_tod = Tod::TimeOfDay.new(active_hours_params['shift_start(4i)'], active_hours_params['shift_start(5i)'])
        break_start_tod = Tod::TimeOfDay.new(active_hours_params['break_start(4i)'], active_hours_params['break_start(5i)'])
        break_end_tod = Tod::TimeOfDay.new(active_hours_params['break_end(4i)'], active_hours_params['break_end(5i)'])
        shift_end_tod = Tod::TimeOfDay.new(active_hours_params['shift_end(4i)'], active_hours_params['shift_end(5i)'])

        print @ubs.attributes

        render json: {
          shift_start: shift_start_tod.to_s,
          break_start: break_start_tod.to_s,
          break_end: break_end_tod.to_s,
          shift_end: shift_end_tod.to_s
        }
      end
    end
  end

  def slot_duration
  end

  private

  def set_ubs
    @ubs = Ubs.find_by(user: current_user)
  end

  def active_hours_params
    params.require(:ubs).permit(:shift_start, :shift_end, :break_start, :break_end)
  end

  def slot_duration_params
    params.require(:ubs).permit(:slot_duration_minutes)
  end
end
