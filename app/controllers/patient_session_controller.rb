class PatientSessionController < ApplicationController
  before_action :authenticate_patient!
end
