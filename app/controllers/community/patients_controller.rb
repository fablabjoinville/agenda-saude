module Community
  class PatientsController < Base
    skip_before_action :authenticate!, only: %i[new create]

    FIELDS = %i[
      birthday
      email
      groups
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

      # FIXME: use group_ids instead
      @patient.target_audience = Patient.target_audiences["without_target"]
      @patient.groups = Group.where id: params.require(:patient).permit(groups: [])['groups']

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

      # FIXME
      @patient.target_audience = Patient.target_audiences["without_target"]
      @patient.groups = Group.where id: params.require(:patient).permit(groups: [])['groups']

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
      params.require(:patient).permit(*(FIELDS + [:cpf]))
    end

    def update_params
      params.require(:patient).permit(*FIELDS)
    end
  end
end
