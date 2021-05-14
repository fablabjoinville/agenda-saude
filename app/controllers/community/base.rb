module Community
  class Base < ApplicationController
    prepend_before_action :authenticate!

    protected

    def authenticate!
      if current_patient
        Appsignal.tag_request(patient_id: current_patient.id)

        return current_patient
      end

      redirect_to(root_path)
    end
  end
end
