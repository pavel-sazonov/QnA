class QuestionSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(user, question)
    SubscriptionMailer.question_subscription(user, question)
  end
end
