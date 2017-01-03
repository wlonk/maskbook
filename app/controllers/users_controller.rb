class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
    if params[:tags]
      @villains = @user.villains.tagged_with(params[:tags]).newest_first.paginate(page: params[:page])
    else
      @villains = @user.villains.newest_first.paginate(page: params[:page])
    end
  end
end
