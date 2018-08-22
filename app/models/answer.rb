class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question

  validates :body, presence: true
  validates :body, length: { minimum: 5 }, allow_nil: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc, created_at: :asc) }

  def set_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  after_create :calculate_rating

  private

  def calculate_rating
    CalculateReputationJob.perform_later self
  end
end
