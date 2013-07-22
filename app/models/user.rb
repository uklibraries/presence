class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :trackable, :validatable

  include Blacklight::User

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :roles
  # attr_accessible :title, :body

  ROLES = [:admin, :uploader]
  
  def roles=(roles)
    self.roles_mask = (roles.map(&:to_sym) & ROLES).map {|r| 2**ROLES.index(r)}.sum
  end

  def roles
    ROLES.reject {|r| ((roles_mask || 0) & 2**ROLES.index(r)).zero?}
  end

  def role_symbols
    roles.map(&:to_sym)
  end

  def role?(role)
    roles.include? role
  end

  def to_s
    self.username
  end

  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)
  end
end
