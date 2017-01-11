require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "tokenize_string" do
    it "splits on spaces" do
      expected = [
        "this",
        "is",
        "a",
        "test",
      ]
      @controller = SearchController.new
      actual = @controller.send(:tokenize, "this is a test")
      expect(expected).to eq(actual)
    end

    it "keeps quoted strings together" do
      expected = [
        "this is",
        "not",
        "a test",
      ]
      @controller = SearchController.new
      actual = @controller.send(:tokenize, '"this is" not \'a test\'')
      expect(expected).to eq(actual)
    end
  end

  describe "parse_query" do
    it "handles quoted query strings" do
      @controller = SearchController.new
      actual = @controller.send(:parse_query, '"tag:has a space" gleep')
      expect(actual).to eq([["has a space"], [], [], "gleep"])
    end
  end

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
