class Question < ApplicationRecord
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { in: 5..50 }, allow_nil: true
  validates :body, length: { minimum: 5 }, allow_nil: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
