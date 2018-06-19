require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe '#author_of?' do
    it 'Returns true if item belongs to user' do
      expect(author).to be_author_of(question)
    end

    it 'Returns false if item does not belong to user' do
      expect(user).to_not be_author_of(question)
    end
  end

  describe "#vote" do
    it "creates new user's vote" do
      expect { user.vote(question, 1) }.to change(user.votes, :count).by(1)
    end

    it "set value of created user's vote" do
      user.vote(question, 1)
      expect(user.votes.last.value).to eq 1
    end

    it "doesn't create new vote if user has already voted" do
      user.vote(question, 1)
      expect { user.vote(question, 1) }.to_not change(Vote, :count)
    end

    it "doesn't create new vote if user is author of resouce" do
      expect { author.vote(question, 1) }.to_not change(Vote, :count)
    end
  end
end
