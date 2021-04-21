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
      @patient.attributes = update_params

      @appointment = current_patient.appointments.not_checked_in.current
      if @patient.doses.empty? && @appointment.present? && !@patient.can_schedule?
        flash.now[:alert] =
          t('alerts.cannot_update_profile_due_to_appointment_condition', date: l(@appointment.start, format: :human))
        return render :edit
      end

      if @patient.save
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
