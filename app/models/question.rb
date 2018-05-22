class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { in: 5..50 }, allow_nil: true
  validates :body, length: { minimum: 5 }, allow_nil: true

  accepts_nested_attributes_for :attachments
end
