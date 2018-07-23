require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author) { create(:user) }
  let!(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe ".find_for_oauth" do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    context "user has authorization" do
      it "returns the user" do
        user.authorizations.create(provider: 'github', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user hasn't authorization" do
      context "user exists" do
        let(:auth) { OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '123456',
          info: { email: user.email }
          ) }

        it "doesn't create user" do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context "user doesn't exist" do
      let(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '123456',
          info: { email: 'new@user.com' }
        )
      end

      it "creates new user" do
        expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end
      it "returns new user" do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it "fills user email" do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info.email
      end

      it "creates authorization for new user" do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it "creates authorization with provider and uid" do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end

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
