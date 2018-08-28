class QuestionSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |subscriber|
      SubscriptionMailer.question_subscription(subscriber, answer)
    end
  end
end
