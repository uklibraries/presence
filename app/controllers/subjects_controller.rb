class SubjectsController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json

  def index
    @subjects = Subject.where(:user_id => current_user.id)
    respond_with(@subjects)
  end

  def show
    respond_with(@subject)
  end

  def new
    respond_with(@subject)
  end

  def edit
    respond_with(@subject)
  end

  def create
    @subject.user_id = current_user.id
    if @subject.save
      flash[:notice] = 'Subject was successfully created.'
    end
    respond_with(@subject)
  end

  def update
    if @subject.update_attributes(params[:subject])
      flash[:notice] = 'Subject was successfully updated.'
    end
    respond_with(@subject)
  end

  def destroy
    @subject.destroy
    respond_with(@subject)
  end
end
