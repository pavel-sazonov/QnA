class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  # validates :title, :body, presence: true
  validates :title, length: { in: 10..50 }
  validates :body, length: { minimum: 30 }
end
