# Preview all emails at http://localhost:3000/rails/mailers/daily_mailer
class DailyMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/daily_mailer/digest
  def question_digest
    user = User.first

    DailyMailer.question_digest user
  end
end
