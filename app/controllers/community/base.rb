module Community
  class Base < ApplicationController
    before_action :authenticate_patient!
  end
end
