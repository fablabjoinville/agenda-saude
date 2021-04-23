module Admin
  class PatientsController < Base
    before_action :set_patient, only: %i[show unblock]

    FILTERS = {
      search: 'search',
      all: 'all',
      locked: 'locked'
    }.freeze

    # For now, only showing locked patients
    def index
      patients = Patient.order(:cpf)

      @patients = filter(search(patients))
                  .order(Patient.arel_table[:name].lower.asc)
                  .page(index_params[:page])
                  .per(25)
    end

    def show; end

    def unblock
      @patient.record_successful_login!

      redirect_to admin_patients_path, flash: { notice: "Paciente #{@patient.name} foi desbloqueado." }
    end

    protected

    # Filters out patients
    def filter(patients)
      # use @filter from search, or input from param (permit-listed), or set to default "all"
      @filter ||= (FILTERS.values & [index_params[:filter].to_s]).presence&.first || FILTERS[:all]

      case @filter
      when FILTERS[:locked]
        patients.locked
      else
        patients
      end
    end

    # Searches for specific patients
    def search(patients)
      if index_params[:search].present? && index_params[:search].size >= 1
        @filter = FILTERS[:search] # In case we're searching, use special filter
        @search = index_params[:search]
        return patients.search_for(@search)
      end

      patients
    end

    def set_patient
      @patient = Patient.find(params[:id])
    end

    def index_params
      params.permit(:page, :search, :filter)
    end
  end
end
