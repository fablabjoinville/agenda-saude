module Admin
  class NeighborhoodsController < Base
    before_action :set_neighborhood, only: %i[show edit update destroy]

    def index
      @neighborhoods = Neighborhood.order(:id)
                                   .page(index_params[:page])
                                   .per(100)
    end


    def new
      @neighborhood = Neighborhood.new
    end

    def create
      @neighborhood = Neighborhood.new(neighborhood_params)

      if @neighborhood.save
        redirect_to admin_neighborhood_path(@neighborhood)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @neighborhood.update(neighborhood_params)
        redirect_to admin_neighborhood_path(@neighborhood)
      else
        render :edit
      end
    end

    def destroy
      @neighborhood.destroy!
      redirect_to admin_neighborhoods_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def neighborhood_params
      params.require(:neighborhood).permit(:name)
    end

    def set_neighborhood
      @neighborhood = Neighborhood.find(params[:id])
    end
  end
end
