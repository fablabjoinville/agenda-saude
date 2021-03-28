module Admin
  class PatientsController < Base
    before_action :set_patient, only: %i[unblock]

    # For now, only showing locked patients
    def index
      @patients = Patient.locked
                         .order(:cpf)
                         .page(index_params[:page])
                         .per(100)
    end

    def unblock
      @patient.record_successful_login!

      redirect_to admin_patients_path, flash: { notice: "Paciente #{@patient.name} foi desbloqueado." }
    end

    protected

    def set_patient
      @patient = Patient.find_by!(id: params[:id])
    end

    def index_params
      params.permit(:per_page, :page, :search, :filter)
    end
  end
end
