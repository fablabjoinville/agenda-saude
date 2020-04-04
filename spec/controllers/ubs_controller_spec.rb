require 'rails_helper'

RSpec.describe UbsController, type: :controller do

  describe "GET #active_hours" do
    it "returns http success" do
      get :active_hours
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #slot_duration" do
    it "returns http success" do
      get :slot_duration
      expect(response).to have_http_status(:success)
    end
  end

end
