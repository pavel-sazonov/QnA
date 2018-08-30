require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should be_able_to :do, :search }
    it { should_not be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :me, user }

    context "user" do
      let(:question) { create :question, user: other }
      let(:answer) { create :answer, question: question, user: other }
      let(:comment) { create :comment, user: other, commentable: question }
      let(:attachment) { create :attachment, attachable: question }

      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Attachment }
      it { should be_able_to :create, Comment }

      it { should_not be_able_to %i[update destroy], question, user_id: user.id }
      it { should_not be_able_to %i[update destroy], answer, user_id: user.id }
      it { should_not be_able_to :destroy, comment, user_id: user.id }
      it { should_not be_able_to :set_best, answer, user_id: user.id }
      it { should_not be_able_to :destroy, attachment, user_id: user.id }
    end

    context "author" do
      let(:question) { create :question, user: user }
      let(:answer) { create :answer, question: question, user: user }
      let(:other_answer) { create :answer, question: question, user: other }
      let(:comment) { create :comment, user: user, commentable: question }
      let(:subscription) { create :subscription, user: user }
      let(:attachment) { create :attachment, attachable: question }

      it { should be_able_to %i[update destroy], question, user_id: user.id }
      it { should be_able_to %i[update destroy], answer, user_id: user.id }
      it { should be_able_to :destroy, comment, user_id: user.id }
      it { should be_able_to :set_best, other_answer, user_id: user.id }
      it { should be_able_to :destroy, attachment, user_id: user.id }
    end

    context "vote" do
      let(:question) { create :question, user: user }
      let(:other_question) { create :question, user: other }

      it { should be_able_to %i[vote_up vote_down], other_question, user_id: user.id }
      it { should_not be_able_to %i[vote_up vote_down], question }

      context "cancel_vote" do
        let!(:vote) { create :vote, user: user, votable: other_question }
        let!(:other_vote) { create :vote, user: other, votable: question }

        it { should be_able_to :cancel_vote, other_question, user_id: user.id }
        it { should_not be_able_to :cancel_vote, question, user_id: user.id }
      end
    end

    context 'subscription' do
      let(:question) { create :question }
      let!(:subscription) { create :subscription, user: user, question: question }
      let!(:other_subscription) { create :subscription }

      it { should be_able_to :subscribe, Question }
      it { should_not be_able_to :subscribe, question }

      it { should be_able_to :destroy, subscription }
      it { should_not be_able_to :destroy, other_subscription }
    end
  end
end
