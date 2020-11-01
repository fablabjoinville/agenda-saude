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
    :sus,
    :target_audience,
    :bedridden,
    :public_place,
    :place_number
  ].freeze

  # POST /patients
  def create
    fields = params.require(:patient).permit(*FIELDS)
    fields[:bedridden] = false
    fields[:target_audience] = Patient.target_audiences["without_target"]
    fields = convert_birth_date(fields)

    patient = Patient.new(fields)
    patient.last_appointment = nil

    # return render 'patients/not_allowed' unless patient.allowed_age?

    patient.save

    return render json: { errors: patient.errors, fields: fields } unless patient.persisted?

    sign_in(patient, scope: :patient)

    return redirect_to index_bedridden_path if patient.bedridden?

    redirect_to index_time_slot_path
  end

  # GET /patients/sign_up
  def new
    @cpf = params[:cpf]

    super
  end

  # GET /patients/edit
  def edit
    super
  end

  # PUT /patients
  def update
    fields = params.require(:patient).permit(*FIELDS)
    fields = convert_birth_date(fields)

    @patient = Patient.find_by(cpf: fields[:cpf])

    if @patient.update_without_password(fields)
      flash[:notice] = 'Dados editados com sucesso!'
      redirect_to index_time_slot_path
    else
      return render json: { errors: patient.errors, fields: fields }
    end
  end

  private

  def convert_birth_date(fields)
    day = fields.delete("birth_date(3i)")
    month = fields.delete("birth_date(2i)")
    year = fields.delete("birth_date(1i)")

    fields[:birth_date] = '%04d-%02d-%02d' % [year, month, day]
    fields
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
