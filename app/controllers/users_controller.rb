class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @villains = @user.villains
  end
end
