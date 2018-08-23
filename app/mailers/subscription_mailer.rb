class SubscriptionMailer < ApplicationMailer
  def question_subscription(user, question)
    @question = question

    mail to: user.email, subject: 'New question answers'
  end
end
