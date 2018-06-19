require "rails_helper"

shared_examples "voted" do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'POST #vote_up' do
    before { sign_in user }

    it 'saves a new user vote in the database' do
      expect { post :vote_up, params: { question_id: question.id, format: :js } }
        .to change(question.votes, :count).by(1)
    end

    # it "renders vote json" do
    #   post :vote_up
    #   expect(response).to have_http_status(:success)
    # end
  end
end

describe QuestionsController, type: :controller do
  it_behaves_like "voted"
end
