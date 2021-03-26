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
        index_time_slot_path
      end
    )
  end
end
