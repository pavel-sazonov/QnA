class DailyMailer < ApplicationMailer
  def question_digest(user)
    @questions = Question.last_day

    mail to: user.email, subject: 'Daily questions digest'
  end
end
