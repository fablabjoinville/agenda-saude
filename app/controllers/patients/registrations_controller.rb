# frozen_string_literal: true

class Patients::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  FIELDS = [
    :name,
    :cpf,
    :mother_name,
    :birth_date,
    :phone,
    :neighborhood,
    :email,
    :other_phone,
    :sus
  ].freeze

  # POST /patients
  def create
    fields = params.require(:patient).permit(*FIELDS)

    patient = Patient.new(fields)

    return render 'patients/age_not_allowed' if patient.years_old >= 60

    patient.save

    return render json: { errors: patient.errors, fields: fields } unless patient.persisted?

    sign_in(patient, scope: :patient)
    redirect_to index_time_slot_path
  end

  # GET /resource/sign_up
  def new
    @cpf = params[:cpf]

    super
  end
end
