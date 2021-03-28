module Admin
  class Base < ApplicationController
    http_basic_authenticate_with name: Rails.configuration.x.admin_username,
                                 password: Rails.configuration.x.admin_password
  end
end
