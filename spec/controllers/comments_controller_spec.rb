require 'rails_helper'
require 'json'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'POST #create' do
    context 'valid attributes' do
      before { sign_in(user) }

      it "creates question's comment" do
        expect { post :create, params: {
          comment: attributes_for(:comment),
          question_id: question,
          format: :json
        } }
          .to change(question.comments, :count).by(1)
      end

      it "creates user's comment" do
        expect { post :create, params: {
          comment: attributes_for(:comment),
          question_id: question,
          format: :json
        } }
          .to change(user.comments, :count).by(1)
      end

      it "response with proper json" do
        post :create, params: {
          comment: attributes_for(:comment),
          question_id: question,
          format: :json
        }

        response_json = JSON.parse(response.body)
        expect(response_json['comment']['id']).to eq comment.id + 1
        expect(response_json['comment']['body']).to eq comment.body
      end
    end

    context "invalid attributes" do
      before { sign_in(user) }

      it "does not save comment in database" do
        expect { post :create, params: {
          comment: attributes_for(:invalid_comment),
          question_id: question,
          format: :json
        } }
          .to_not change(Comment, :count)
      end

      it "response with proper json" do
        post :create, params: {
          comment: attributes_for(:invalid_comment),
          question_id: question,
          format: :json
        }

        response_json = JSON.parse(response.body)
        expect(response_json['errors']['body'].first).to eq "can't be blank"
        expect(response_json['errors']['body'].last).to eq "is too short (minimum is 5 characters)"
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author of comment tries to delete his comment' do
      before { sign_in(user) }

      it "deletes question's comment" do
        expect { delete :destroy, params: { id: comment, format: :json } }
          .to change(question.comments, :count).by(-1)
      end

      it "deletes user's comment" do
        expect { delete :destroy, params: { id: comment, format: :json } }
          .to change(user.comments, :count).by(-1)
      end

      it "response with proper json" do
        delete :destroy, params: { id: comment, format: :json }

        response_json = JSON.parse(response.body)
        expect(response_json['comment_id']).to eq comment.id
      end
    end

    context 'Non-author tries delete answer' do
      before { sign_in(another_user) }

      it 'does not delete comment' do
        expect { delete :destroy, params: { id: comment, format: :json } }
          .to_not change(question.comments, :count)
      end
    end

    context 'Non authenticate user tries delete comment' do
      it 'does not delete comment from database' do
        expect { delete :destroy, params: { id: comment, format: :json } }
          .to_not change(Comment, :count)
      end
    end
  end
end
