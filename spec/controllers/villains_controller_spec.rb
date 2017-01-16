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
      expect(response).to redirect_to(
        controller: "devise/sessions",
        action: "new"
      )
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

      expect(response).to redirect_to(
        controller: "devise/sessions",
        action: "new"
      )
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

      expect(response).to redirect_to(assigns(:villain))
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
end
