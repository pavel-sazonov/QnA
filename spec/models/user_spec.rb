require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of(item)?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'Returns true if item belongs to user' do
      expect(question.user_id).to eq user.id
    end

    it 'Returns false if item does not belong to user' do
      expect(question.user_id).to_not eq another_user.id
    end
  end
end
