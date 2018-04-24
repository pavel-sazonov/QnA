class Answer < ApplicationRecord
  belongs_to :question

  validates :body, length: { minimum: 30 }, allow_nil: true
  validates :body, presence: true
end
