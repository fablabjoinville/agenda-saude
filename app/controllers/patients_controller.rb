class PatientsController < UserSessionController
  before_action :set_ubs

  def show
    @patient = Patient.find(params[:id])
    @appointments = @patient.appointments
  end

  private

  def set_ubs
    @ubs = Ubs.find_by(user: current_user)
  end
end
