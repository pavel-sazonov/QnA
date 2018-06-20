module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    # scope :voted_by, ->(user) { votes.where(user: user) }
  end

  def raiting
    votes.pluck(:value).sum
  end

  def voted_by(user)
    votes.where(user: user)
  end
end
