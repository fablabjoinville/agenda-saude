module Admin
  class VaccinesController < Base
    before_action :set_vaccine, only: %i[show edit update destroy]

    def index
      @vaccines = Vaccine.order(:id)
                         .page(index_params[:page])
                         .per(100)
    end

    def new
      @vaccine = Vaccine.new
    end

    def create
      @vaccine = Vaccine.new(vaccine_params)

      if @vaccine.save
        redirect_to admin_vaccine_path(@vaccine)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @vaccine.update(vaccine_params)
        redirect_to admin_vaccine_path(@vaccine)
      else
        render :edit
      end
    end

    def destroy
      @vaccine.destroy! if @vaccine.doses.empty?

      redirect_to admin_vaccines_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def vaccine_params
      params.require(:vaccine).permit(:name, :formal_name, :legacy_name,
                                      :second_dose_after_in_days, :third_dose_after_in_days)
    end

    def set_vaccine
      @vaccine = Vaccine.find(params[:id])
    end
  end
end
