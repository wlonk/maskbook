require "rails_helper"

RSpec.describe VillainsController, type: :controller do
  describe "GET #index" do
    it "always filters for the current user" do
      user1 = create(:user)
      user2 = create(:user)
      villain1 = create(:villain, user: user1)
      villain2 = create(:villain, user: user1, public: false)
      villain3 = create(:villain, user: user2, public: false)
      sign_in user2
      get :index

      expect(response).to be_success
      # Newest first by default, so:
      expect(assigns(:villains)).to eq([villain3, villain1])
    end
  end

  describe "GET #show" do
    it "shows a villain" do
      user1 = create(:user)
      user2 = create(:user)
      villain = create(:villain, user: user1)
      sign_in user2
      get :show, params: { id: villain.friendly_id }

      expect(response).to be_success
      expect(assigns(:villain)).to eq(villain)
    end
  end

  describe "GET #new" do
    it "displays a form for a new villain" do
      user = create(:user)
      sign_in user
      get :new

      expect(response).to be_success
      expect(assigns(:villain).user).to eq(user)
    end

    it "doesn't for unloggedin users" do
      get :new
      expect(response).to redirect_to("/")
    end
  end

  describe "GET #edit" do
    it "displays a form to edit a villain" do
      user = create(:user)
      villain = create(:villain, user: user)
      sign_in user
      get :edit, params: { id: villain.friendly_id }

      expect(response).to be_success
      expect(assigns(:villain)).to eq(villain)
    end

    it "doesn't for unloggedin users" do
      villain = create(:villain)
      get :edit, params: { id: villain.friendly_id }

      expect(response).to redirect_to("/")
    end
  end

  describe "POST #create" do
    it "saves a villain on a successful post" do
      user = create(:user)
      sign_in user
      post :create, params: { villain: {
        name: "Villain McVillainface",
      } }

      expect(response).to redirect_to(assigns(:villain))
      expect(Villain.all.length).to eq(1)
    end

    it "re-renders the form on a bad post" do
      user = create(:user)
      sign_in user
      post :create, params: { villain: { name: "" } }

      expect(response).to be_success
      expect(Villain.all.length).to eq(0)
    end
  end

  describe "PUT #update" do
    it "updates the villain" do
      user = create(:user)
      villain = create(:villain, user: user)
      sign_in user
      put :update, params: {
        id: villain.friendly_id,
        villain: {
          name: "Villain McVillainface",
        }
      }

      expect(response).to redirect_to(assigns(:villain))
      expect(Villain.all.length).to eq(1)
    end

    it "bounces you if it's not your villain" do
      user1 = create(:user)
      user2 = create(:user)
      villain = create(:villain, user: user1)
      sign_in user2
      put :update, params: {
        id: villain.friendly_id,
        villain: {
          name: "Villain McVillainface",
        }
      }

      expect(response).to redirect_to("/")
      expect(villain.name).to eq("Baron Blade")
    end

    it "re-renders the form on a bad put" do
      user = create(:user)
      villain = create(:villain, user: user)
      sign_in user
      put :update, params: {
        id: villain.friendly_id,
        villain: { name: "" }
      }

      expect(response).to be_success
      expect(villain.name).to eq("Baron Blade")
    end

    it "allows you to update fields if you're a collaborator" do
      user1 = create(:user)
      user2 = create(:user)
      villain = create(:villain, user: user1, collaborators: [user2])
      sign_in user2
      put :update, params: {
        id: villain.friendly_id,
        villain: { name: "Citizen Dawn" }
      }

      expect(response).to redirect_to(assigns(:villain))
      expect(Villain.where(name: "Citizen Dawn").exists?)
    end

    it "doesn't allow you to update the collaborator list as a collaborator" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      villain = create(:villain, user: user1, collaborators: [user2])
      sign_in user2
      put :update, params: {
        id: villain.friendly_id,
        villain: { collaborator_ids: [user3.id] }
      }

      expect(Villain.find(villain.id).collaborators).to eq([user2])
    end

    context "affiliations" do
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = create(:user)
        sign_in @user

        @user2 = create(:user)
        @villain1 = create(:villain, name: "Mine", user: @user)
        @villain2 = create(:villain, name: "Yours", user: @user2)
        @villain3 = create(:villain, name: "Ours", user: @user2, collaborators: [@user])

        @organization1 = create(:organization, name: "Mine", user: @user)
        @organization2 = create(:organization, name: "Yours", user: @user2)
      end

      it "lets you add affiliations if you own both ends" do
        put :update, params: {
          id: @villain1.to_param,
          villain: {
            organization_ids: [@organization1.id]
          }
        }
        @villain1.reload
        expect(@villain1.organizations).to eq([@organization1])
      end

      it "lets you add affiliations if you collaborate or edit both ends" do
        put :update, params: {
          id: @villain3.to_param,
          villain: {
            organization_ids: [@organization1.id]
          }
        }
        @villain3.reload
        expect(@villain3.organizations).to eq([@organization1])
      end

      it "does not let you add affiliations if either side is not editable" do
        put :update, params: {
          id: @villain2.to_param,
          villain: {
            organization_ids: [@organization1.id]
          }
        }
        @villain2.reload
        expect(@villain2.organizations).to eq([])
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the villain" do
      user = create(:user)
      villain = create(:villain, user: user)
      sign_in user
      delete :destroy, params: { id: villain.friendly_id }

      expect(response).to redirect_to(
        controller: "villains",
        action: "index"
      )
      expect(Villain.all.length).to eq(0)
    end
  end

  describe "POST #favorite" do
    it "fails for an unauth'd user" do
      villain = create(:villain)
      post :favorite, params: { id: villain.friendly_id }

      expect(response.response_code).to eq(403)
      expect(Favorite.all.length).to eq(0)
    end

    it "favs when there is no fav" do
      user = create(:user)
      villain = create(:villain)
      sign_in user
      post :favorite, params: { id: villain.friendly_id, format: 'json' }

      expect(response.response_code).to eq(200)
      expect(Favorite.all.length).to eq(1)
    end

    it "unfavs when there is a fav" do
      user = create(:user)
      villain = create(:villain)
      fav = create(:favorite, villain: villain, user: user)
      sign_in user
      post :favorite, params: { id: villain.friendly_id, format: 'json' }

      expect(response.response_code).to eq(200)
      expect(Favorite.all.length).to eq(0)
    end
  end

  describe "#all_tags" do
    it "gets all tags" do
      get :all_tags, params: { format: 'json' }
      
      expect(response.body).to eq('[]')
    end
  end
end
