module Admin
  class UsersController < Base
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.order(User.arel_table[:name].lower.asc)
                   .page(index_params[:page])
                   .per(100)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_user_path(@user)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def edit_user_params
      return @edit_user_params if @edit_user_params

      @edit_user_params = user_params.to_h
      if !@edit_user_params[:password].presence && !@edit_user_params[:password_confirmation].presence
        @edit_user_params.delete(:password)
        @edit_user_params.delete(:password_confirmation)
      end

      @edit_user_params
    end

    def update
      if @user.update(edit_user_params)
        redirect_to admin_user_path(@user)
      else
        render :edit
      end
    end

    def destroy
      @user.destroy! unless @user == current_user
      redirect_to admin_users_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :administrator, ubs_ids: [])
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
