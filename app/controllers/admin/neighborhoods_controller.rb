module Admin
  class NeighborhoodsController < Base
    before_action :set_neighborhood, only: %i[show]

    def index
      @neighborhoods = Neighborhood.order(:id)
                                   .page(index_params[:page])
                                   .per(100)
    end

    def show; end

    private

    def index_params
      params.permit(:page)
    end

    def set_neighborhood
      @neighborhood = Neighborhood.find(params[:id])
    end
  end
end
