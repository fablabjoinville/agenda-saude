module Admin
  class GroupsController < Base
    before_action :set_group, only: %i[show edit update destroy]

    def index
      @groups = Group.admin_order
                     .page(index_params[:page])
                     .per(100)
    end

    def new
      @group = Group.new
    end

    def create
      @group = Group.new(group_params)

      if @group.save
        redirect_to admin_group_path(@group)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @group.update(group_params)
        redirect_to admin_group_path(@group)
      else
        render :edit
      end
    end

    def destroy
      @group.destroy!
      redirect_to admin_groups_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def group_params
      params.require(:group).permit(:name, :parent_group_id, :context, :position, :active)
    end

    def set_group
      @group = Group.find(params[:id])
    end
  end
end
