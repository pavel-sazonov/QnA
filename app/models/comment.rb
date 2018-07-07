class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
  validates :body, length: { minimum: 5 }, allow_nil: true

  default_scope { order(created_at: :asc) }
end
