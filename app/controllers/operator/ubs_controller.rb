module Operator
  class UbsController < Base
    def show; end

    def activate
      @ubs.update!(active: true)

      redirect_to[:operator, @ubs]
    end

    def suspend
      @ubs.update!(active: false)

      redirect_to[:operator, @ubs]
    end
  end
end
