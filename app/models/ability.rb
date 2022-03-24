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
    can :update, User, id: user.id
    
    if user.has_role? "admin"
      can :create, User
    elsif user.has_role? "manager"
      can :create, Project
      can [:update, :destroy], Project, creator_id: user.id
    elsif user.has_role? "employee"
      
    end

    # if user.manager?
    #   can :edit
    # end
  end
end
