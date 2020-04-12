require 'rails_helper'

RSpec.describe TimeSlotController, type: :controller do

  describe "GET #schedule" do
    it "requires authentication and returns status 302" do
      get :schedule
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #index" do
    it "requires authentication and returns status 302" do
      get :index
      expect(response).to have_http_status(:redirect)
    end
  end

end
