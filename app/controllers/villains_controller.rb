class VillainsController < ApplicationController
  include Devise::Controllers::Helpers 

  def new
    @villain = current_user.villains.build if user_signed_in?
    authorize! :create, @villain
  end

  def create
    @villain = current_user.villains.build(villain_params)
    authorize! :create, @villain
    if @villain.save
      redirect_to @villain
    else
      render 'new'
    end
  end

  def index
    @filterrific = initialize_filterrific(
      Villain.all_for(current_user),
      params[:s],
      select_options: {
        sorted_by: Villain.options_for_sorted_by,
      },
      persistence_id: false
    ) or return
    @villains = @filterrific.find.paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @villains }
      format.atom { render layout: false }
    end
  end

  def show
    @villain = Villain.friendly.find(params[:id])
    authorize! :read, @villain
    set_meta_tags description: "#{@villain.name}: #{@villain.drive}"
    set_meta_tags og: {
      type: 'website',
      title: @villain.name,
      description: @villain.drive,
      url: URI.join(request.url, villain_url(@villain)),
      image: URI.join(request.url, @villain.mugshot.url(:medium)),
    }
    set_meta_tags twitter: {
      card: "summary",
    }
    respond_to do |format|
      format.html
      format.json { render json: @villain }
    end
  end

  def edit
    @villain = Villain.friendly.find(params[:id])
    authorize! :update, @villain
  end

  def update
    @villain = Villain.friendly.find(params[:id])
    authorize! :update, @villain
    is_owner = @villain.user == current_user
    if @villain.update(villain_params(is_owner))
      redirect_to @villain
    else
      render 'edit'
    end
  end

  def destroy
    @villain = Villain.friendly.find(params[:id])
    authorize! :destroy, @villain
    @villain.destroy
    flash[:success] = "Villain deleted"
    redirect_to action: 'index', status: 303
  end

  def favorite
    unless current_user.nil?
      @villain = Villain.friendly.find(params[:id])
      begin
        Favorite.create(villain: @villain, user: current_user)
      rescue ActiveRecord::RecordNotUnique
        Favorite.where(villain: @villain, user: current_user).destroy_all
      end
      @count = Favorite.where(villain: @villain).count
      respond_to do |format|
        format.json { render json: @count }
      end
    else
      render status: :forbidden, plain: "Authentication required"
    end
  end

  def all_tags
    @tags = Villain.tag_counts
    respond_to do |format|
      format.json { render json: @tags }
    end
  end

  private

  def villain_params(is_owner=true)
    # @TODO you can add an organization you don't own, though it won't show up
    # in the interface.
    ret = params.require(:villain).permit(
      :name,
      :real_name,
      :generation,
      :drive,
      :moves,
      :abilities,
      :description,
      :mugshot,
      :public,
      :tag_list => [],
      :organization_ids => [],
      :collaborator_ids => [],
      :condition_ids => [],
    )
    unless is_owner
      ret.except(:collaborator_ids)
    else
      ret
    end
  end
end
