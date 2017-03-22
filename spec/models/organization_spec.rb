require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe "#all_editable_by" do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @organization1 = create(:organization, user: @user1)
      @organization2 = create(:organization, user: @user2)
    end

    it "should return organizations you own" do
      expect(Organization.all_editable_by(@user1)).to include(@organization1)
    end

    it "should not return organizations you do not own" do
      expect(Organization.all_editable_by(@user1)).not_to include(@organization2)
    end

    it "should return nothing if you are not logged in" do
      expect(Organization.all_editable_by(nil)).to eq(Organization.none)
    end
  end
end
