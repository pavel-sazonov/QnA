class DailyQuestionDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each { |user| DailyMailer.question_digest(user).deliver_later }
  end
end
