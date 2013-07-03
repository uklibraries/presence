class RegistrationsController < Devise::RegistrationsController
  before_filter :prevent_unauthorized_role_setting, :only => [:create, :update]

  def prevent_unauthorized_role_setting
    if cannot? :manage, :users
      params[:user].delete_if {|k, v| k.to_sym == :roles_mask}
    end
  end
end
