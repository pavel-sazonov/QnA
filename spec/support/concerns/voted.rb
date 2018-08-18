require "rails_helper"

shared_examples_for "Voted" do
  let(:params) { { id: votable.id, format: :json } }
  before { sign_in user }

  describe 'POST #vote_up' do
    let(:request) { post :vote_up, params: params }
    let(:rating) { 1 }
    let(:changed_users_votes_count) { 1 }

    it_behaves_like 'Voted action'
  end

  describe 'POST #vote_down' do
    let(:request) { post :vote_down, params: params }
    let(:rating) { -1 }
    let(:changed_users_votes_count) { 1 }

    it_behaves_like 'Voted action'
  end

  describe 'DELETE #cancel_vote' do
    let(:request) { delete :cancel_vote, params: params }
    let(:rating) { 0 }
    let(:changed_users_votes_count) { -1 }
    let!(:vote) { create :vote, user: user, votable: votable }

    it_behaves_like 'Voted action'
  end
end
