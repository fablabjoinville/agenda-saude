module Operator
  class Base < UserSessionController
    before_action :set_ubs

    private

    def set_ubs
      @ubs = current_user.ubs
    end
  end
end
