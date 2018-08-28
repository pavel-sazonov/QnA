class QuestionSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.each do |subscription|
      SubscriptionMailer.question_subscription(subscription.user, answer)
    end
  end
end
