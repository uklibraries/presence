class Ability
  include CanCan::Ability

  def initialize(user)
    #cannot :manage, :user
    can :read, :all

    if user.role? :admin
      can :manage, User
    end
  end
end
