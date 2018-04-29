require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }

  describe 'POST #create' do
    context 'valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: {
          answer: attributes_for(:answer),
          question_id: question,
          user_id: @user
          } }.to change(question.answers, :count).by(1)
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
end
