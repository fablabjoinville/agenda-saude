module Admin
  class UsersController < Base
    def index
      @users = User.order(User.arel_table[:name].lower.asc)
                   .page(index_params[:page])
                   .per(25)
    end

    def show
      @user = User.find(params[:id])
    end

    private

    def index_params
      params.permit(:page)
    end
  end
end
