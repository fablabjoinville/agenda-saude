module Operator
  class UbsController < Base
    before_action :set_ubs, only: %i[show activate suspend]

    def index
      redirect_to operator_ubs_appointments_path(current_user.ubs.order(:id).first)
    end

    def show; end

    def activate
      @ubs.update!(active: true)

      redirect_to operator_ubs_path(id: @ubs.id)
    end

    def suspend
      @ubs.update!(active: false)

      redirect_to operator_ubs_path(id: @ubs.id)
    end

    private

    def set_ubs
      @ubs = current_user.ubs.find(params[:id])
    end
  end
end
