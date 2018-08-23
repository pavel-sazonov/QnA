require 'rails_helper'

RSpec.describe DailyQuestionDigestJob, type: :job do
  let(:users) { create_list :user, 2 }

  it 'sends questions daily digest' do
    users.each do |user|
      expect(DailyMailer).to receive(:question_digest).with(user).and_call_original
    end

    DailyQuestionDigestJob.perform_now
  end
end
