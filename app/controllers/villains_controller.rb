class VillainsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :is_owner?, only: [:edit, :update, :destroy]

  def new
    @villain = current_user.villains.build if logged_in?
  end

  def create
    @villain = current_user.villains.build(villain_params)
    if @villain.save
      redirect_to @villain
    else
      render 'new'
    end
  end

  def index
    @villains = Villain.all
  end

  def show
    @villain = Villain.find(params[:id])
  end

  def edit
    @villain = Villain.find(params[:id])
  end

  def update
    @villain = current_user.villains.build(villain_params)
    if @villain.save
      redirect_to @villain
    else
      render 'edit'
    end
  end

  def destroy
    @villain = Villain.find(params[:id])
    @villain.destroy
    flash[:success] = "Villain deleted"
    redirect_to action: 'index', status: 303
  end

  private

    def villain_params
      params.require(:villain).permit(
        :name,
        :drive,
        :moves,
        :conditions,
        :abilities,
        :description,
      )
    end

    def is_owner?
      @villain = current_user.villains.find_by(id: params[:id])
      redirect_to root_url if @villain.nil?
    end
end
