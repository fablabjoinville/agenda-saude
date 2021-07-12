module Admin
  class PatientsController < Base
    before_action :set_patient, only: %i[show unblock edit update]
    skip_before_action :require_administrator!, only: %i[index show unblock new create edit update]

    FILTERS = {
      search: 'search',
      all: 'all',
      locked: 'locked'
    }.freeze

    # For now, only showing locked patients
    def index
      @patients = filter(search(Patient.order(:cpf)))
                  .order(Patient.arel_table[:name].lower.asc)
                  .page(index_params[:page])
                  .per(100)
    end

    def new
      @patient = Patient.new
    end

    def create
      @patient = Patient.new(patient_params)

      if @patient.save
        redirect_to admin_patient_path(@patient)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @patient.update(patient_params)
        redirect_to admin_patient_path(@patient)
      else
        render :edit
      end
    end

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

      patients.where('TRUE IS FALSE') # to return empty
    end

    def set_patient
      @patient = Patient.find(params[:id])
    end

    def index_params
      params.permit(:page, :search, :filter)
    end

    def patient_params
      params.require(:patient).permit(
        :cpf,
        :name, :birthday, :mother_name,
        :phone, :other_phone,
        :public_place, :place_number, :street_2, :neighborhood_id,
        :email, :sus,
        group_ids: []
      )
    end
  end
end
