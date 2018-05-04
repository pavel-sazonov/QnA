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
      expect(user.author_of?(question)).to eq true
    end

    it 'Returns false if item does not belong to user' do
      expect(another_user.author_of?(question)).to eq false
    end
  end
end
