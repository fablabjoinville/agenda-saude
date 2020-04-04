class UserSessionController < ApplicationController
  before_action :authenticate_user!
end
