module Admin
  class UbsController < Base
    before_action :set_ubs, only: %i[show edit update destroy]

    def index
      @ubs = Ubs.order(Ubs.arel_table[:name].lower.asc)
                .page(index_params[:page])
                .per(100)
    end

    def new
      @ubs = Ubs.new
    end

    def create
      @ubs = Ubs.new(ubs_params)

      if @ubs.save
        redirect_to admin_ubs_path(@ubs)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @ubs.update(ubs_params)
        redirect_to admin_ubs_path(@ubs)
      else
        render :edit
      end
    end

    def destroy
      @ubs.destroy!
      redirect_to admin_ubs_index_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def ubs_params
      params.require(:ubs).permit(
        :name, :cnes, :active,
        :shift_start, :break_start, :break_end, :shift_end,
        :saturday_shift_start, :saturday_break_start, :saturday_break_end, :saturday_shift_end,
        :sunday_shift_start, :sunday_break_start, :sunday_break_end, :sunday_shift_end,
        :slot_interval_minutes, :appointments_per_time_slot,
        :address, :neighborhood_id, :phone
      )
    end

    def set_ubs
      @ubs = Ubs.find(params[:id])
    end
  end
end
