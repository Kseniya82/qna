# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, :all
    can :search, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscription], user_id: user.id

    can :best, Answer, question: { user_id: user.id }

    can :manage, ActiveStorage::Attachment do |file|
      user.author? file.record
    end

    can [:vote_up, :vote_down], [Question, Answer] do |item|
      !user.author? item
    end

    can :vote_destroy, [Question, Answer], votes: { user_id: user.id }

    can [:create, :destroy], Link, linkable: { user_id: user.id }

    can :create, Award, question: { user_id: user.id  }

    can :me, User, user_id: user.id
  end
end
