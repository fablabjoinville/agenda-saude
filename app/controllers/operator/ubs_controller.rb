module Operator
  class UbsController < Base
    def show; end

    def activate
      @ubs.update!(active: true)

      redirect_to operator_ubs_path(id: @ubs.id)
    end

    def suspend
      @ubs.update!(active: false)

      redirect_to operator_ubs_path(id: @ubs.id)
    end
  end
end
