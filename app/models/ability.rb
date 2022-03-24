# frozen_string_literal: true

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
    can [:update, :edit], User, id: user.id

    if user.has_role? "admin"
      can :manage, User
      can :manage, Role
      can :manage, Project
    elsif user.has_role? "manager"
      # can :create, Project
      can :manage, Project, creator_id: user.id
    elsif user.has_role? "employee"
      
    else
      can :show, Project, client_id: user.id
    end

    # if user.manager?
    #   can :edit
    # end
  end
end
