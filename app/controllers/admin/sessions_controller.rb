# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  after_action :ignore_flash
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create 
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  # end

  private

  def ignore_flash
    flash.delete(:notice)
  end
end
    