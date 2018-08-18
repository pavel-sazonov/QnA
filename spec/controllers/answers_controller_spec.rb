require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:votable) { create :answer }

  it_behaves_like "Voted"

  describe 'POST #create' do
    before { sign_in(user) }

    context 'valid attributes' do
      it 'saves a new user answer in the database' do
        expect { post :create, params: {
          answer: attributes_for(:answer),
          question_id: question,
          format: :js
        } }.to change(user.answers, :count).by(1)
      end

      it 'saves a new question answer in the database' do
        expect { post :create, params: {
          answer: attributes_for(:answer),
          question_id: question,
          format: :js
        } }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: {
          answer: attributes_for(:answer),
          question_id: question,
          format: :js
        }
        expect(response).to render_template :create
      end
    end

    context 'invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: {
          answer: attributes_for(:invalid_answer),
          question_id: question,
          format: :js
        } }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: {
          answer: attributes_for(:invalid_answer),
          question_id: question,
          format: :js
        }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author tries delete answer' do
      before { sign_in(user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }
          .to change(user.answers, :count).by(-1)
      end

      it 'render updated template' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Non-author tries delete answer' do
      before { sign_in(another_user) }

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }
          .to_not change(Answer, :count)
      end

      it 'does not render updated template' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to_not render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Author' do
      before { sign_in(user) }

      context 'tries update answer with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'render updated template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'tries update answer with invalid attributes' do
        it 'does not changes answer attributes' do
          old_body = answer.body
          patch :update, params: { id: answer, answer: { body: '' }, format: :js }
          answer.reload
          expect(answer.body).to eq old_body
        end

        it 'render updated template' do
          patch :update, params: { id: answer, answer: { body: '' }, format: :js }
          expect(response).to render_template :update
        end
      end
    end

    context 'Non-author tries update answer' do
      before { sign_in another_user }

      it 'does not change answer attributes' do
        old_body = answer.body

        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
        expect(answer.body).to eq old_body
      end
    end
  end

  describe 'PATCH #best' do
    context 'Author of question tries set answer as best' do
      it 'set answer best attribute to true' do
        sign_in user
        patch :set_best, params: { id: answer, answer: { best: true }, format: :js }
        answer.reload
        expect(answer.best).to eq true
      end
    end

    context 'Non-author of question tries set answer as best' do
      it 'does not set answer best attribute to true' do
        sign_in another_user
        patch :set_best, params: { id: answer, answer: { best: true }, format: :js }
        answer.reload
        expect(answer.best).to_not eq true
      end
    end
  end
end
