class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      ubs_index_path
    else
      appointments_path
    end
  end
end
