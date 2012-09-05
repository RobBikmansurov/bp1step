class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new

    if user.role? :admin
      #can :manage, :all
      can :manage, [User, Document]
      can :destroy, [User, Document]
      can :update, [Document]
    elsif user.role? :analitic
      can :destroy, [Bproce, BusinessRole, Workplace, Bapp]
      can :create, [Bproce, BusinessRole, Workplace, Bapp]
      can :update, [Bproce, BusinessRole, Workplace, Bapp, Document]
    else
      can :read, :all
      if user.role? :user
        #can :create, Post
        #can :update, Post do |post|
          #post.try(:user) == user
        #end
      end
    end
    
    unless user.new_record?
    can :update, Bproce do |bproce|
      #!bproce.users.include?(user)    
    end
  end
        
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
