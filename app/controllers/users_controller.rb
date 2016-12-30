class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
    @villains = @user.villains
  end
end
