class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      ubs_index_path
    elsif resource.is_a?(Patient)
      index_time_slot_path
    else
      root_path
    end
  end
end
