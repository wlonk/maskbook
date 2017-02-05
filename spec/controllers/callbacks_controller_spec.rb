require 'rails_helper'

RSpec.describe CallbacksController, type: :controller do
  describe "#twitter" do
    before(:each) do
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
        provider: "twitter",
        uid: "1234",
        info: {
          name: "Testarr",
          email: "test@example.com",
        },
      })
    end

    it "should populate user from omniauth" do
      get :twitter
      user = User.find_by(provider: "twitter")

      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#google_oauth2" do
    before(:each) do
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
        provider: "google_oauth2",
        uid: "1234",
        info: {
          name: "Testarr",
          email: "test@example.com",
        },
      })
    end

    it "should populate user from omniauth" do
      get :google_oauth2
      user = User.find_by(provider: "google_oauth2")

      expect(assigns(:user)).to eq(user)
    end
  end
end
