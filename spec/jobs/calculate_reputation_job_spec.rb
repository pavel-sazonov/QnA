require 'rails_helper'

RSpec.describe CalculateReputationJob, type: :job do
  let(:answer) { create :answer }

  it 'calculates reputation' do
    expect(Reputation).to receive(:calculate).with answer
    CalculateReputationJob.perform_now answer

    # expect(Reputation).to receive(:calculate).with(answer).and_return 5
    # expect { CalculateReputationJob.perform_now answer }.to change(user, :reputation).by 5
  end
end
