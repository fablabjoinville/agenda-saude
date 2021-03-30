module Operator
  class Base < ApplicationController
    before_action :authenticate_user!
    before_action :set_ubs

    private

    def set_ubs
      @ubs = current_user.ubs
    end
  end
end
