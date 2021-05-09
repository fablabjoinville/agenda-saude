module Admin
  class UsersController < Base
    before_action :set_user, only: %i[show]

    def index
      @users = User.order(User.arel_table[:name].lower.asc)
                   .page(index_params[:page])
                   .per(100)
    end

    def show; end

    private

    def index_params
      params.permit(:page)
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
