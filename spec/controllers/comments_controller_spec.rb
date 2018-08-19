require 'rails_helper'
require 'json'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'POST #create' do
    before { sign_in user }

    context 'valid attributes' do
      it "creates question's comment" do
        expect { do_request(:comment) }
          .to change(question.comments, :count).by(1)
      end

      it "creates user's comment" do
        expect { do_request(:comment) }
          .to change(user.comments, :count).by(1)
      end

      it 'response with proper json' do
        do_request(:comment)

        response_json = JSON.parse(response.body)
        expect(response_json['id']).to eq comment.id + 1
        expect(response_json['body']).to eq comment.body
      end
    end

    context 'invalid attributes' do
      it 'does not save comment in database' do
        expect { do_request(:invalid_comment) }
          .to_not change(Comment, :count)
      end

      it 'response with proper json' do
        do_request(:invalid_comment)

        response_json = JSON.parse(response.body)
        expect(response_json['errors']['body'].first).to eq "can't be blank"
        expect(response_json['errors']['body'].last).to eq "is too short (minimum is 5 characters)"
      end
    end

    def do_request(comment)
      post :create, params: {
        comment: attributes_for(comment),
        question_id: question,
        format: :json
      }
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create :user }
    let(:do_request) { delete :destroy, params: { id: comment, format: :json } }

    context 'Author of comment tries to delete his comment' do
      before { sign_in(user) }

      it "deletes question's comment" do
        expect { do_request }
          .to change(question.comments, :count).by(-1)
      end

      it "deletes user's comment" do
        expect { do_request }
          .to change(user.comments, :count).by(-1)
      end

      it 'response with proper json' do
        do_request

        response_json = JSON.parse(response.body)
        expect(response_json['comment_id']).to eq comment.id
      end
    end

    let(:model) { Comment }
    it_behaves_like 'Deletable'
  end
end
