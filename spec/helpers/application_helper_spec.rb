require "rails_helper"

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
RSpec.describe ApplicationHelper, type: :helper do
  describe "#markdown" do
    it "renders basic markdown" do
      actual = helper.markdown("_emphasis_")
      expected = "<p><em>emphasis</em></p>\n"
      expect(actual).to eq(expected)
    end
  end

  describe "#quote_if_needed" do
    it "quotes strings with spaces" do
      actual = helper.quote_if_needed("user:Kit Person")
      expect(actual).to eq('"user:Kit Person"')
    end

    it "doesn't quote strings without spaces" do
      actual = helper.quote_if_needed("user:Kit")
      expect(actual).to eq("user:Kit")
    end
  end
end
