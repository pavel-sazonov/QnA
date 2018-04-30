require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: {
          answer: attributes_for(:answer),
          question_id: question,
          user_id: user
          } }.to change(user.answers, :count).by(1)
      end

      it "redirect to question's show view" do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.
        to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, question: question, user: user) }

    context 'Author tries delete answer' do
      before do
        answer
        sign_in(user)
      end

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to change(user.answers, :count).by(-1)
      end

      it 'redirects to show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'Non-author tries delete answer' do
      before do
        answer
        sign_in(another_user)
      end

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it "redirects to question's show view" do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
