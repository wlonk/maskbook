class VillainsController < ApplicationController
  include Devise::Controllers::Helpers 

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :is_owner?, only: [:edit, :update, :destroy]

  def new
    @villain = current_user.villains.build if user_signed_in?
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
    @villains = Villain.paginate(page: params[:page])
  end

  def show
    @villain = Villain.friendly.find(params[:id])
  end

  def edit
    @villain = Villain.friendly.find(params[:id])
  end

  def update
    @villain = Villain.friendly.find(params[:id])
    if @villain.update(villain_params)
      redirect_to @villain
    else
      render 'edit'
    end
  end

  def destroy
    @villain = Villain.friendly.find(params[:id])
    @villain.destroy
    flash[:success] = "Villain deleted"
    redirect_to action: 'index', status: 303
  end

  private

    def villain_params
      params.require(:villain).permit(
        :name,
        :real_name,
        :generation,
        :drive,
        :moves,
        :abilities,
        :description,
        :mugshot,
        :condition_ids => [],
      )
    end

    def is_owner?
      villain = current_user.villains.friendly.find_by(slug: params[:id])
      if villain.nil?
        villain = Villain.friendly.find(params[:id])
        redirect_to villain
      end
    end
end
