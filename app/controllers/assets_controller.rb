class AssetsController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json
  before_filter :get_package

  def get_package
    @package = Package.find(params[:package_id])
  end
  
  def index
    @assets = Asset.where(user_id => current_user.id)
    respond_with(@assets)
  end

  def show
    respond_with(@package)
  end

  def new
    @asset = @package.assets.build
    respond_with(@package)
  end

  def edit
    respond_with(@package)
  end

  def create
    logger.debug("DEBUG: AssetsController#create")
    @asset = @package.assets.build(
      :name => params[:filename]
    )
    @asset.user_id = current_user.id
    if @asset.save
      render json: @asset
    end
    # Eager method:
    #logger.debug("DEBUG: #{params[:asset].inspect}")
    #@asset = @package.assets.first_or_create(
    #  :name => params[:asset]["file"].original_filename
    #)
    #@chunk = @asset.chunks.build("chunk" => params[:asset]["file"])
    #@chunk.user_id = current_user.id
    #if @chunk.save
    #  flash[:notice] = 'Asset was successfully created.'
    #end
  end

  def update
    if @asset.update_attributes(params[:asset])
      flash[:notice] = 'Asset was successfully updated.'
    end
    respond_with(@package)
  end

  def destroy
    @asset.destroy
    respond_with(@package)
  end
end
