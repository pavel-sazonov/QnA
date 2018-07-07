require "rails_helper"

shared_examples_for "voted" do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  before { sign_in user }

  describe 'POST #vote_up' do
    it 'saves a new user vote in the database' do
      expect { post :vote_up, params: { id: question.id, format: :json } }
        .to change(user.votes, :count).by(1)
    end

    it "response with success" do
      post :vote_up, params: { id: question.id, format: :json }
      expect(response.status).to eq 200
      expect(response).to have_http_status(:success)
    end

    it "response with proper json" do
      post :vote_up, params: { id: question.id, format: :json }
      expect(response.body).to eq "{\"rating\":1,\"votable_id\":#{question.id}}"
    end
  end

  describe 'POST #vote_down' do
    it 'saves a new user vote in the database' do
      expect { post :vote_down, params: { id: question.id, format: :json } }
        .to change(user.votes, :count).by(1)
    end

    it "response with success" do
      post :vote_down, params: { id: question.id, format: :json }
      expect(response.status).to eq 200
    end

    it "response with proper json" do
      post :vote_down, params: { id: question.id, format: :json }
      expect(response.body).to eq "{\"rating\":-1,\"votable_id\":#{question.id}}"
    end
  end

  describe 'DELETE #cancel_vote' do
    before { post :vote_up, params: { id: question.id, format: :json } }

    it 'deletes user vote from the database' do
      expect { post :cancel_vote, params: { id: question.id, format: :json } }
        .to change(user.votes, :count).by(-1)
    end

    it "response with success" do
      post :cancel_vote, params: { id: question.id, format: :json }
      expect(response.status).to eq 200
    end

    it "response with proper json" do
      post :cancel_vote, params: { id: question.id, format: :json }
      expect(response.body).to eq "{\"rating\":0,\"votable_id\":#{question.id}}"
    end
  end
end
