require 'rails_helper'

RSpec.describe UbsController, type: :controller do

  describe "GET #active_hours" do
    it "requires authentication and returns status 302" do
      get :active_hours
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #slot_duration" do
    it "requires authentication and returns status 302" do
      get :slot_duration
      expect(response).to have_http_status(:redirect)
    end
  end
end
