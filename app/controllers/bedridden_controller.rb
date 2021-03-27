class BedriddenController < ApplicationController
  def index
    render 'patients/bedridden'
  end

  def toggle
    current_patient.update!(bedridden: !current_patient.bedridden?)

    redirect_to(
      if current_patient.bedridden?
        index_bedridden_path
      else
        home_community_appointments_path
      end
    )
  end
end
