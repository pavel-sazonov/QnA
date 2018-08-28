require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let!(:subscriptions) { create_list :subscription, 2, question: question }

  it 'sends question subscription' do
    answer.question.subscriptions.each do |subscription|
      expect(SubscriptionMailer).to receive(:question_subscription).with(subscription.user, answer)
    end

    QuestionSubscriptionJob.perform_now(answer)
  end
end
