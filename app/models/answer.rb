class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
  validates :body, length: { minimum: 30 }, allow_nil: true
end
