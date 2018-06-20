require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'attachable'
  it_behaves_like 'authorable'
  it_behaves_like 'votable'

  it { should belong_to :question }

  it { should validate_presence_of :body }
  it do
    should validate_length_of(:body).
    is_at_least(5)
  end
  it { should have_db_index(:user_id) }
  it { should have_db_index(:question_id) }

  describe '#set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: user) }

    before { answer.set_best }

    it 'Set answer the best ' do
      expect(answer).to be_best
    end

    it 'if there was best answer set it to non best' do
      another_answer.set_best
      answer.reload

      expect(another_answer).to be_best
      expect(answer).to_not be_best
    end
  end

  it { should accept_nested_attributes_for :attachments }
end
