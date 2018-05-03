require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array from all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders new edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new user question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.
        to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.
        to_not change(Question, :count)
      end

      it 're-renders new view ' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil } } }

      it 'does not change question attributes' do
        original_question = question

        question.reload

        expect(question.title).to eq original_question.title
        expect(question.body).to eq original_question.body
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:user_question) { create(:question, user: @user) }

    context 'Author tries delete question' do
      before { user_question }

      it 'deletes question' do
        expect { delete :destroy, params: { id: user_question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: user_question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Non-author tries delete question' do
      before { question }

      it 'does not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to show view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
