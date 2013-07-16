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

  def freeze
    @asset = @package.assets.where(
      :name => params[:filename]
    ).first
    authorize! :manage, @asset
    unless @asset.finalized?
      @asset.finalized = true
      if @asset.save
        AssemblyWorker.perform_async(@asset.id)
      end
    end
    render json: {
      :name => @asset.name,
      :url => package_asset_path(@package, @asset)
    }
  end

  def create
    @asset = @package.assets.where(
      :name => params[:asset]["file"].original_filename
    ).first_or_create
    @asset.user_id = current_user.id
    authorize! :manage, @asset

    # Only allow active uploads to be modified
    return if @asset.finalized?

    if @asset.save
      @chunk = @asset.chunks.build("chunk" => params[:asset]["file"])
      @chunk.user_id = current_user.id
      authorize! :manage, @chunk
      if @chunk.save
        flash[:notice] = 'Asset was successfully created.'
      end
    end
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
