class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { in: 5..50 }, allow_nil: true
  validates :body, length: { minimum: 5 }, allow_nil: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :last_day, -> { where('created_at >= ?', (Date.today - 1.day).to_time) }

  after_create :subscribe_author

  private

  def subscribe_author
    user.subscriptions.create(question: self)
  end
end
