module Admin
  class PatientsController < Base
    before_action :set_patient, only: %i[show unblock]

    # For now, only showing locked patients
    def index
      patients = Patient.order(:cpf)
                        .page(index_params[:page])
                        .per(25)

      if index_params[:search].present?
        patients = patients.search_for(index_params[:search])
      end

      @patients = patients.page(index_params[:page])
                          .per(25)

      @patients = @patients.locked if index_params[:filter] == 'locked'
    end

    def show; end

    def unblock
      @patient.record_successful_login!

      redirect_to admin_patients_path, flash: { notice: "Paciente #{@patient.name} foi desbloqueado." }
    end

    protected

    def set_patient
      @patient = Patient.find(params[:id])
    end

    def index_params
      params.permit(:page, :search, :filter)
    end
  end
end
