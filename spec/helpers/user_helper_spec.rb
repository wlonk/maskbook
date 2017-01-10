require "rails_helper"

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
RSpec.describe UsersHelper, type: :helper do
  describe "gravatar_for" do
    it "gets a gravatar for a given email" do
      user = build(:user)
      actual = helper.gravatar_for(user)
      name = "Alex Rodriguez"
      url = "https://secure.gravatar.com/avatar/fa028cdc19589078e49959d1f9b9b7b6?s=80"
      expected = "<img alt=\"#{name}\" class=\"gravatar\" src=\"#{url}\" />"
      expect(actual).to eq(expected)
    end
  end
end
