class OrganizationsController < ApplicationController
  include Devise::Controllers::Helpers 
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all.paginate(page: params[:page])
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @related_villains = @organization.villains.paginate(page: params[:page])
  end

  # GET /organizations/new
  def new
    @organization = current_user.organizations.build
    authorize! :create, @organization
  end

  # GET /organizations/1/edit
  def edit
    authorize! :update, @organization
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = current_user.organizations.build(organization_params)
    authorize! :create, @organization

    if @organization.save
      redirect_to @organization
    else
      render 'new'
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    authorize! :update, @organization
    if @organization.update(organization_params)
      redirect_to @organization
    else
      render 'edit'
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    redirect_to organizations_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      available_villains = Villain.all_editable_by(current_user).pluck(:id)
      params.require(:organization).permit(
        :name,
        :description,
        :villain_ids => [],
      ).to_h.map { |k, v|
        if k == "villain_ids"
          [k, v.select { |id| available_villains.include? id.to_i }]
        else
          [k, v]
        end
      }.to_h
    end
end
