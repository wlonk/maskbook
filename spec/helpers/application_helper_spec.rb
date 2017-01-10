require "rails_helper"

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
RSpec.describe ApplicationHelper, type: :helper do
  describe "markdown" do
    it "renders basic markdown" do
      actual = helper.markdown("_emphasis_")
      expected = "<p><em>emphasis</em></p>\n"
      expect(actual).to eq(expected)
    end
  end
end
