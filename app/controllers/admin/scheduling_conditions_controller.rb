module Admin
  class SchedulingConditionsController < Base
    before_action :set_scheduling_condition, only: %i[show edit update destroy]

    def index
      @scheduling_conditions = SchedulingCondition.order(:id)
                                                  .page(index_params[:page])
                                                  .per(100)
    end

    def new
      @scheduling_condition = SchedulingCondition.new active: true
    end

    def create
      @scheduling_condition = SchedulingCondition.new(scheduling_condition_params)

      if @scheduling_condition.save
        redirect_to admin_scheduling_condition_path(@scheduling_condition)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @scheduling_condition.update(scheduling_condition_params)
        redirect_to admin_scheduling_condition_path(@scheduling_condition)
      else
        render :edit
      end
    end

    def destroy
      @scheduling_condition.destroy!
      redirect_to admin_scheduling_conditions_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def scheduling_condition_params
      params.require(:scheduling_condition).permit(:name, :start_at, :active, :min_age, :max_age, group_ids: [])
    end

    def set_scheduling_condition
      @scheduling_condition = SchedulingCondition.find(params[:id])
    end
  end
end
