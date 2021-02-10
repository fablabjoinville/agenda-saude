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
    @ubs_all = Ubs.all
  end

  # GET admin/ubs/new
  def new
    @ubs = Ubs.new
  end

  # POST admin/ubs
  def create
    fields = params.require(:ubs).permit(*FIELDS)
    time_fields = params.require(:ubs).permit(:shift_start, :shift_end)

    binding.pry

    shift_start_tod = Tod::TimeOfDay.parse("#{time_fields['shift_start(4i)']}:#{time_fields['shift_start(5i)']}")
    shift_end_tod = Tod::TimeOfDay.parse("#{time_fields['shift_end(4i)']}:#{time_fields['shift_end(5i)']}")

    shift_start = Tod::TimeOfDay.parse(shift_start_tod).on(Date.today).in_time_zone
    shift_end = Tod::TimeOfDay.parse(shift_end_tod).on(Date.today).in_time_zone

    ubs = Ubs.new(fields)
    ubs.shift_start = shift_start.to_s
    ubs.break_start = shift_start.to_s
    ubs.break_end = shift_start.to_s
    ubs.shift_end = shift_end.to_s
    ubs.saturday_shift_start = shift_start.to_s
    ubs.saturday_break_start = shift_start.to_s
    ubs.saturday_break_end = shift_start.to_s
    ubs.saturday_shift_end = shift_end.to_s
    ubs.active = false

    ubs.save!

    if @ubs.update(fields)
      flash[:notice] = 'Unidade criada com sucesso!'
      redirect_to admin_ubs_index_path
    else
      return redirect_to edit_admin_ubs_path(@ubs), alert: @ubs.errors
    end
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


end
    