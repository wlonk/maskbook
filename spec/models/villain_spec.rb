require "rails_helper"

RSpec.describe Villain, type: :model do
  describe "tokenize_string" do
    it "splits on spaces" do
      actual = Villain.send(:tokenize, "this is a test")
      expected = [
        "this",
        "is",
        "a",
        "test",
      ]
      expect(expected).to eq(actual)
    end

    it "keeps quoted strings together" do
      actual = Villain.send(:tokenize, '"this is" not \'a test\'')
      expected = [
        "this is",
        "not",
        "a test",
      ]
      expect(expected).to eq(actual)
    end
  end

  describe "parse_query" do
    it "handles quoted query strings" do
      actual = Villain.send(:parse_query, '"tag:has a space" gleep')
      expected = [
        ["has a space"],
        [],
        [],
        "gleep",
      ]
      expect(actual).to eq(expected)
    end

    it "handles nil queries (for some reason)" do
      actual = Villain.send(:parse_query, nil)
      expected = [[], [], [], ""]
      expect(actual).to eq(expected)
    end
  end

  describe "sorted_by" do
    before do
      user1 = create(:user, name: "C")
      user2 = create(:user, name: "A")
      user3 = create(:user, name: "B")
      @first = create(:villain, name: "B", user: user1)
      @second = create(:villain, name: "C", user: user2)
      @third = create(:villain, name: "A", user: user3)
    end

    it "sorts ascending" do
      actual = Villain.sorted_by("created_at_asc")
      expected = [@first, @second, @third]
      expect(actual).to eq(expected)
    end

    it "sorts descending" do
      actual = Villain.sorted_by("created_at_desc")
      expected = [@third, @second, @first]
      expect(actual).to eq(expected)
    end

    it "sorts by name" do
      actual = Villain.sorted_by("name_asc")
      expected = [@third, @first, @second]
      expect(actual).to eq(expected)
    end

    it "sorts by user" do
      actual = Villain.sorted_by("user_asc")
      expected = [@second, @third, @first]
      expect(actual).to eq(expected)
    end

    it "bails on anything else" do
      expect{Villain.sorted_by("gleep_glorp")}.to raise_error(ArgumentError)
    end
  end
end
