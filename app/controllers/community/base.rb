module Community
  class Base < ApplicationController
    prepend_before_action :authenticate!

    protected

    def authenticate!
      current_patient || redirect_to(root_path)
    end
  end
end
