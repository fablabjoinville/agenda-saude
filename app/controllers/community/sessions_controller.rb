module Community
  class SessionsController < Base
    skip_before_action :authenticate!, only: %i[create destroy]

    def create
      @patient = Patient.find_by(cpf: session_params[:cpf])

      return redirect_to(new_community_patient_path(patient: { cpf: session_params[:cpf] })) unless @patient

      session[:patient_id] = @patient.id

      redirect_to home_community_appointments_path
    end

    def destroy
      session[:patient_id] = nil

      redirect_to root_path
    end

    protected

    def session_params
      params.require(:patient).permit(:cpf, :mothers_name)
    end
  end
end
