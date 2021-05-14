module Community
  class Base < ApplicationController
    prepend_before_action :authenticate!

    protected

    def authenticate!
      if current_patient
        Sentry.set_user(patient_id: current_patient.id)

        return current_patient
      end

      redirect_to(root_path)
    end
  end
end
