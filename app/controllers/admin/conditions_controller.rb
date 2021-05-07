module Admin
  class ConditionsController < Base
    before_action :set_condition, only: %i[show edit update destroy]

    def index
      @conditions = Condition.order(start_at: :desc, end_at: :desc)
                             .page(index_params[:page])
                             .per(100)
    end

    def new
      start_at = Time.zone.now.beginning_of_day + 10.hours # 10am as default

      @condition = Condition.new start_at: start_at,
                                 end_at: start_at + 1.month,
                                 can_register: true,
                                 can_schedule: true
    end

    def create
      @condition = Condition.new(condition_params)

      if @condition.save
        redirect_to admin_condition_path(@condition)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @condition.update(condition_params)
        redirect_to admin_condition_path(@condition)
      else
        render :edit
      end
    end

    def destroy
      @condition.destroy!
      redirect_to admin_conditions_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def condition_params
      params.require(:condition).permit(:name, :start_at, :end_at, :min_age, :max_age, :can_register, :can_schedule,
                                        group_ids: [], ubs_ids: [])
    end

    def set_condition
      @condition = Condition.find(params[:id])
    end
  end
end
