require 'pry'

class AppointmentsController < ApplicationController
  # For some reason sometimes current_user is retunirng nil
  # before_action :user?, except: %i[new create]
  # before_action :patient?, only: %i[new create]

  def index; end

  def show; end

  def new; end

  def create; end

  def update; end

  def destroy; end

  private

  def user?
    render json: 'sem permissão' unless current_user.present?
  end

  def patient?
    render json: 'sem permissão' unless current_patient.present?
  end
end
