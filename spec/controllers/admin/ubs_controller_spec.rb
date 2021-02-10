require 'rails_helper'

RSpec.describe Admin::UbsController, type: :controller do

  describe "GET #new" do
    it "requires authentication and returns status 302" do
      get :new
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
