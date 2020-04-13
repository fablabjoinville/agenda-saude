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
    :bedridden
  ].freeze

  # POST /patients
  def create
    fields = params.require(:patient).permit(*FIELDS)
    fields[:bedridden] = fields[:bedridden] == '1'

    patient = Patient.new(fields)

    p_year = patient.birth_date[0..3].to_i
    p_month = patient.birth_date[5..6].to_i
    p_day = patient.birth_date[8..9].to_i

    now_year = DateTime.now.strftime('%Y').to_i
    now_month = DateTime.now.strftime('%m').to_i
    now_day = DateTime.now.strftime('%d').to_i


    if p_year > (now_year - 60) or
      (p_year == (now_year - 60) and p_month >= now_month and p_day > now_day)
      return render 'patients/age_not_allowed'
    end

    patient.save

    return render json: { errors: patient.errors, fields: fields } unless patient.persisted?

    sign_in(patient, scope: :patient)

    return redirect_to index_bedridden_path if patient.bedridden?

    redirect_to index_time_slot_path
  end

  # GET /resource/sign_up
  def new
    @cpf = params[:cpf]

    super
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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
