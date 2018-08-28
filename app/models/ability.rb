class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    return unless user.present?
    can :me, User
    can :create, [Question, Answer, Attachment, Comment]

    can :subscribe, Question do |question|
      user.subscriptions.where(question: question).empty?
    end

    can :destroy, Subscription do |subscribe|
      user.subscriptions.where(question: subscribe.question).any?
    end

    can %i[update destroy], [Question, Answer], user_id: user.id
    can :destroy, Comment, user_id: user.id

    can :destroy, Attachment, attachable: { user_id: user.id }
    can :set_best, Answer, question: { user_id: user.id }

    can %i[vote_up vote_down], [Question, Answer] do |votable|
      !user.author_of?(votable) && votable.voted_by(user).empty?
    end

    can :cancel_vote, [Question, Answer] do |votable|
      votable.votes.where(user_id: user.id).present?
    end
  end
end
