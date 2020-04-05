require 'rails_helper'

RSpec.describe TimeSlotController, type: :controller do

  describe "GET #schedule" do
    it "returns http success" do
      get :schedule
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
