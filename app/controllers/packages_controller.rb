class PackagesController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json

  def index
    @packages = Package.where(:user_id => current_user.id)
    @subjects = Subject.where(:user_id => current_user.id).order(:subject)
    respond_with(@packages)
  end

  def show
    @subjects = @package.subjects
    respond_with(@package)
  end

  def new
    respond_with(@package)
  end

  def edit
    @subjects = Subject.where(:user_id => current_user.id).order(:subject)
    respond_with(@package)
  end

  def create
    @package.user_id = current_user.id
    if @package.save
      flash[:notice] = 'Package was successfully created'
    end
    respond_with(@package)
  end

  def update
    if @package.update_attributes(params[:package])
      flash[:notice] = 'Package was successfully updated.'
    end
    respond_with(@package)
  end

  def destroy
    @package.destroy
    respond_with(@package)
  end
end
