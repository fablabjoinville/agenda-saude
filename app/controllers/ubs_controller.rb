class UbsController < UserSessionController
  before_action :set_ubs

  def active_hours
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
