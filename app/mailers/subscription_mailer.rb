class SubscriptionMailer < ApplicationMailer
  def question_subscription(user, answer)
    @answer = answer

    mail to: user.email, subject: "New answers for #{answer.question.title}"
  end
end
