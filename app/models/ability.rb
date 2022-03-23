class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    if user.has_role? "admin"
      can :create, User
    else
      can :update, User, user_id: user.id
    end

    # if user.manager?
    #   can :edit
    # end
  end
end
