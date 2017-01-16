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

  describe "options_for_sorted_by" do
    it "is in order" do
      expected = [
        ['Name (a-z)', 'name_asc'],
        ['Name (z-a)', 'name_desc'],
        ['Creation date (newest first)', 'created_at_desc'],
        ['Creation date (oldest first)', 'created_at_asc'],
        ['Creator name (a-z)', 'user_asc'],
        ['Creator name (z-a)', 'user_desc'],
      ]
      actual = Villain.options_for_sorted_by
      expect(actual).to eq(expected)
    end
  end

  describe "search_query" do
    before do
      user = create(:user, name: "Flora")
      @first = create(:villain)
      @second = create(:villain)
      @third = create(:villain, user: user)

      @first.tag_list.add("first")
      @second.generation = "Silver"

      @first.save
      @second.save
    end

    it "bails on empty queries" do
      expect(Villain.search_query(nil)).to eq(Villain.all)
      expect(Villain.search_query("")).to eq(Villain.all)
    end

    it "filters down to matching tags" do
      actual = Villain.search_query("tag:first").map { |v| v.attributes }
      expected = Villain.where(id: @first.id).map {|v| v.attributes }
      expect(actual).to eq(expected)
    end

    it "filters down to matching generations" do
      actual = Villain.search_query("gen:silver").map { |v| v.attributes }
      expected = Villain.where(id: @second.id).map {|v| v.attributes }
      expect(actual).to eq(expected)
    end

    it "filters down to matching users" do
      actual = Villain.search_query("user:flora").map { |v| v.attributes }
      expected = Villain.where(id: @third.id).map {|v| v.attributes }
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

  describe "public" do
    it "should only show up for the creator unless it's public" do
      user1 = create(:user)
      user2 = create(:user)
      villain1 = create(:villain, user: user1)
      villain2 = create(:villain, user: user1, public: false)
      villain3 = create(:villain, user: user1)

      actual = Villain.all_for(user1)
      expect(actual).to eq([villain1, villain2, villain3])
      actual = Villain.all_for(user2)
      expect(actual).to eq([villain1, villain3])
      actual = Villain.all_for(nil)
      expect(actual).to eq([villain1, villain3])
    end
  end
end
