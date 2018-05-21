class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { in: 5..50 }, allow_nil: true
  validates :body, length: { minimum: 5 }, allow_nil: true
end
