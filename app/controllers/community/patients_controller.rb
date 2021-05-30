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
      street_2
      sus
    ].freeze

    def new
      @patient = Patient.new create_params
    end

    def create
      @patient = Patient.new create_params
      @patient.user_updated_at = Time.zone.now

      if @patient.save
        session[:patient_id] = @patient.id
        redirect_to home_community_appointments_path,
                    flash: {
                      notice_title: t('alerts.successful_patient_creation_title'),
                      notice: t('alerts.successful_patient_creation_message')
                    }
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
      @patient.user_updated_at = Time.zone.now

      unless can_update_profile?
        flash.now[:cy] = 'cannotUpdateProfileDueToAppointmentConditionText'
        flash.now[:alert] = t('alerts.cannot_update_profile_due_to_appointment_condition')
        render :edit
        return
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

    # If doesn't have a current appointment, was already given a dose, allow them to all changes they'd like to
    # Otherwise check if patient can schedule (checking the conditions)
    def can_update_profile?
      !@patient.appointments.current || # if there's no appointment, allow
        @patient.doses.count.positive? || # if there's already a dose, allow
        @patient.can_schedule? || # if it's the user 1st dose and there's an appointment, check if they can still schedule
        @patient.could_schedule_in_the_past? # if user was every able to schedule in the past
    end

    def create_params
      params.require(:patient).permit(*(FIELDS + [:cpf]), group_ids: [], inquiry_answer_ids: [])
    end

    def update_params
      params.require(:patient).permit(*FIELDS, group_ids: [], inquiry_answer_ids: [])
    end
  end
end
