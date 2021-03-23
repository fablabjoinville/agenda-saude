class BedriddenController < ApplicationController
  def index
    render 'patients/bedridden'
  end

  def toggle
    patient = current_patient
    patient.bedridden = !patient.bedridden?
    patient.save!

    return redirect_to index_bedridden_path if patient.bedridden?

    redirect_to index_time_slot_path
  end
end
