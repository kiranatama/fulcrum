class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Admin exception
    can :manage, :all and return if user.admin?

    # default ability for all users
    can :create,  Project
    can :read,    Project,  :id => user.project_ids

    # specific ability for each role

    ## Owner
    # Could only manage *owned* projects and it's members
    can :manage,  Project,  :projects_users => {:role => "owner", :user_id => user.id }
  end
end
