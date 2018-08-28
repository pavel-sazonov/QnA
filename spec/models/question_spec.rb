require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'attachable'
  it_behaves_like 'authorable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it do
    should validate_length_of(:title).
    is_at_least(5).is_at_most(50)
  end

  it do
    should validate_length_of(:body).
    is_at_least(5)
  end

  it { should have_db_index(:user_id) }
  it { should accept_nested_attributes_for :attachments }

  describe '#subscribe_author' do
    let(:user) { create(:user) }
    let!(:question) { create :question, user: user }

    it 'should subscribes author on his question' do
      expect(user.subscriptions.size).to eq 1
      expect(question.subscriptions.size).to eq 1
    end
  end
end
