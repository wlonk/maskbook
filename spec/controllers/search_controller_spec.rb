require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #search" do
    it "returns http success" do
      get :search
      expect(response).to have_http_status(:success)
    end

    it "handles actual query strings" do
      get :search, params: { s: "gen:gold gen:orange tag:blue user:kit free search" }
      expect(response).to have_http_status(:success)
    end
  end
end
