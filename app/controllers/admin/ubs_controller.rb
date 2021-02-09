class Admin::UbsController < Admin::SessionsController
  
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
  
    # GET ubs
    def index
      @ubs_all = Ubs.all
    end
  
    # GET ubs/new
    def new
      @ubs = Ubs.new
      # binding.pry
      # render 'admin/ubs/new'
    end
  
    # POST ubs
    def create
      fields = params.require(:ubs).permit(*FIELDS)
      time_fields = params.require(:ubs).permit(:shift_start_date, :shift_end_date, :break_start_date, :break_end_date)
  
      shift_start_tod = Tod::TimeOfDay.parse("#{time_fields['shift_start_date(4i)']}:#{time_fields['shift_start_date(5i)']}")
      break_start_tod = Tod::TimeOfDay.parse("#{time_fields['break_start_date(4i)']}:#{time_fields['break_start_date(5i)']}")
      break_end_tod = Tod::TimeOfDay.parse("#{time_fields['break_end_date(4i)']}:#{time_fields['break_end_date(5i)']}")
      shift_end_tod = Tod::TimeOfDay.parse("#{time_fields['shift_end_date(4i)']}:#{time_fields['shift_end_date(5i)']}")
  
      ubs = Ubs.new(fields)
      ubs.shift_start = shift_start_tod.to_s
      ubs.break_start = break_start_tod.to_s
      ubs.break_end = break_end_tod.to_s
      ubs.shift_end = shift_end_tod.to_s
      ubs.active = false
  
      ubs.save
  
      if @ubs.update(fields)
        flash[:notice] = 'Unidade atualizada com sucesso!'
        redirect_to ubs_index_path
      else
        return redirect_to edit_ubs_path(@ubs), alert: @ubs.errors
      end
    end
  
    # GET /ubs/edit
    def edit
      @ubs = Ubs.find(params[:id])
    end
  
    # PUT /ubs
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
  
        redirect_to ubs_index_path
      else
        return redirect_to edit_ubs_path(@ubs), alert: @ubs.errors
      end
    end
  
  
  end
    