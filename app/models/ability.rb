class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user.role? :admin
      can :manage, :all
    elsif user.role? :uploader
      can :manage, Package, :user_id => user.id
      can :manage, Subject, :user_id => user.id
      can :manage, Asset, :user_id => user.id
      can :manage, Chunk, :user_id => user.id
    end
  end
end
