class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale
  def set_locale
      I18n.locale = 'pt-BR'
  end
end
