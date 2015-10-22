class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    send "define_#{controller_namespace.downcase}_ability", user
  end

  def define__ability(user)
    can :manage, :all
  end

  def define_admin_ability(user)
    can :manage, :all
  end

  def define_asynces_ability(user)
    can :manage, :all
  end

  def public_page_ability(user)
    can :manage, :all
  end
end
