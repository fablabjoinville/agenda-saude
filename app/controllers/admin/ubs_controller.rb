module Admin
  class UbsController < Base
    before_action :set_ubs, only: %i[show]

    def index
      @ubs = Ubs.order(Ubs.arel_table[:name].lower.asc)
                .page(index_params[:page])
                .per(100)
    end

    def show; end

    private

    def index_params
      params.permit(:page)
    end

    def set_ubs
      @ubs = Ubs.find(params[:id])
    end
  end
end
