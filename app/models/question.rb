class Question < ApplicationRecord

  validates :title, :body, presence: true
  validates :title, length: { in: 10..30 }
  validates :body, length: { minimum: 10 }
end
