module Community
  class Base < ApplicationController
    prepend_before_action :authenticate!

    protected

    def authenticate!
      current_patient || return redirect_to(root_path)

      Sentry.set_user(id: current_patient.id, username: current_patient.cpf)
    end
  end
end
