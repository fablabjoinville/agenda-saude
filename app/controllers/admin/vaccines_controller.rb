module Admin
  class VaccinesController < Base
    before_action :set_vaccine, only: %i[show]

    def index
      @vaccines = Vaccine.order(:id)
                         .page(index_params[:page])
                         .per(100)
    end

    def show; end

    private

    def index_params
      params.permit(:page)
    end

    def set_vaccine
      @vaccine = Vaccine.find(params[:id])
    end
  end
end
