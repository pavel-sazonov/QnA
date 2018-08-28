# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/question_subscription
  def question_subscription
    user = User.first
    answer = Answer.first

    SubscriptionMailer.question_subscription user, answer
  end
end
