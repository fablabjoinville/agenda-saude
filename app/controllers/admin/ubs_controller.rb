module Admin
  class UbsController < Base
    def index
      @ubs = Ubs.order(Ubs.arel_table[:name].lower.asc)
                .page(index_params[:page])
                .per(25)
    end

    def show
      @ubs = Ubs.find(params[:id])
    end

    private

    def index_params
      params.permit(:page)
    end
  end
end
