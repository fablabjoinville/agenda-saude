class Admin::UbsController < AdminController
  
  FIELDS = [
    :name,
    :cnes,
    :phone,
    :address,
    :neighborhood,
    :slot_interval_minutes,
    :appointments_per_time_slot,
    :active
  ].freeze

  # GET admin/ubs
  def index
    @ubs_all = Ubs.all.order(active: :desc)
  end

  # GET admin/ubs/new
  def new
    @ubs = Ubs.new
  end

  # POST admin/ubs
  def create
    fields = params.require(:ubs).permit(*FIELDS)
    time_fields = params.require(:ubs).permit(:shift_start, :shift_end)
    user_ubs = User.last
    
    shift_start_tod = Tod::TimeOfDay.parse("#{time_fields['shift_start(4i)']}:#{time_fields['shift_start(5i)']}")
    shift_end_tod = Tod::TimeOfDay.parse("#{time_fields['shift_end(4i)']}:#{time_fields['shift_end(5i)']}")
    
    shift_start = shift_start_tod.to_s
    shift_end = shift_end_tod.to_s

    ubs = Ubs.new(fields)
    ubs.shift_start = shift_start
    ubs.break_start = shift_start
    ubs.break_end = shift_start
    ubs.shift_end = shift_end
    ubs.saturday_shift_start = shift_start
    ubs.saturday_break_start = shift_start
    ubs.saturday_break_end = shift_start
    ubs.saturday_shift_end = shift_end
    ubs.active = false
    ubs.user = user_ubs

    ubs.save

    redirect_to admin_ubs_index_path
  end

  # GET admin/ubs/edit
  def edit
    @ubs = Ubs.find(params[:id])
  end

  # PUT admin/ubs
  def update
    fields = params.require(:ubs).permit(*FIELDS)
    time_fields = params.require(:ubs).permit(:shift_start_date, :shift_end_date, :break_start_date, :break_end_date)

    shift_start_tod = Tod::TimeOfDay.parse("#{time_fields['shift_start_date(4i)']}:#{time_fields['shift_start_date(5i)']}")
    break_start_tod = Tod::TimeOfDay.parse("#{time_fields['break_start_date(4i)']}:#{time_fields['break_start_date(5i)']}")
    break_end_tod = Tod::TimeOfDay.parse("#{time_fields['break_end_date(4i)']}:#{time_fields['break_end_date(5i)']}")
    shift_end_tod = Tod::TimeOfDay.parse("#{time_fields['shift_end_date(4i)']}:#{time_fields['shift_end_date(5i)']}")

    @ubs = Ubs.find(params[:id])

    updated_time = @ubs.update(
      shift_start: shift_start_tod.to_s,
      break_start: break_start_tod.to_s,
      break_end: break_end_tod.to_s,
      shift_end: shift_end_tod.to_s,
    )

    if @ubs.update(fields) && updated_time
      flash[:notice] = 'Unidade atualizada com sucesso!'

      redirect_to admin_ubs_index_path
    else
      return redirect_to edit_admin_ubs_path(@ubs), alert: @ubs.errors
    end
  end

  def activate
    ubs = Ubs.find(params[:id])
    updated = ubs.update(active: true)

    return redirect_to admin_ubs_index_path if updated
  end

  def deactivate
    ubs = Ubs.find(params[:id])
    updated = ubs.update(active: false)

    return redirect_to admin_ubs_index_path if updated
  end
end
    