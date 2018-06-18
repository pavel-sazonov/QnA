require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'Returns true if item belongs to user' do
      expect(user).to be_author_of(question)
    end

    it 'Returns false if item does not belong to user' do
      expect(another_user).to_not be_author_of(question)
    end
  end
end
