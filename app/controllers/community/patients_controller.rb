module Community
  class PatientsController < Base
    skip_before_action :authenticate!, only: %i[new create]

    FIELDS = %i[
      birthday
      email
      mother_name
      name
      neighborhood
      other_phone
      phone
      place_number
      public_place
      specific_comorbidity
      sus
      target_audience
    ].freeze

    def new
      @patient = Patient.new create_params
    end

    def create
      @patient = Patient.new create_params

      if @patient.save
        session[:patient_id] = @patient.id
        redirect_to home_community_appointments_path
      else
        render :new
      end
    end

    def edit
      @patient = current_patient
    end

    def update
      @patient = current_patient

      if @patient.update(update_params)
        redirect_to home_community_appointments_path, flash: {
          notice: 'Cadastro atualizado.'
        }
      else
        render :edit
      end
    end

    protected

    def create_params
      params.require(:patient).permit(*(FIELDS + [:cpf]), group_ids: [])
    end

    def update_params
      params.require(:patient).permit(*FIELDS, group_ids: [])
    end
  end
end
