module Admin
  class Base < ApplicationController
    before_action :authenticate_user!
    before_action :require_administrator!

    class AdministratorRequired < StandardError; end

    rescue_from AdministratorRequired do |_exception|
      render plain: :forbidden, status: :forbidden
    end

    private

    def require_administrator!
      current_user.administrator || raise(AdministratorRequired)
    end
  end
end
