require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:answer) { create :answer }

  it 'sends question subscription' do
    expect(SubscriptionMailer)
      .to receive(:question_subscription)
      .with(answer.question.user, answer.question)

    QuestionSubscriptionJob.perform_now(answer.question.user, answer.question)
  end
end
