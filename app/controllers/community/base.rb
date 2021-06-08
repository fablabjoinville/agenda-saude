module Community
  class Base < ApplicationController
    include RateLimited

    prepend_before_action :authenticate!

    protected

    def authenticate!
      if current_patient
        Appsignal.tag_request(patient_id: current_patient.id)

        return rate_limit! if exceeded_rate_limit?

        record_on_rate_limit

        return current_patient
      end

      redirect_to(root_path)
    end
  end
end
