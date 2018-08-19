require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:votable) { create :question }

  it_behaves_like 'Voted'

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array from all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
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

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new user question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view ' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:old_question) { question }

    describe 'Author' do
      before { sign_in user }

      context 'tries update question with valid attributes' do
        it 'assigns the requested question to @question' do
          do_request attributes_for(:question)
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          do_request title: 'new title', body: 'new body'
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render updated template' do
          do_request attributes_for(:question)
          expect(response).to render_template :update
        end
      end

      context 'tries update question with invalid attributes' do
        before { do_request title: 'new title', body: nil }

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq old_question.title
          expect(question.body).to eq old_question.body
        end

        it 'render updated template' do
          expect(response).to render_template :update
        end
      end
    end

    context 'Non author tries update question' do
      before { sign_in another_user }

      it 'does not change question attributes' do
        do_request attributes_for(:question)
        question.reload

        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end
    end

    def do_request(question_attributes)
      patch :update, params: { id: question, question: question_attributes, format: :js }
    end
  end

  describe 'DELETE #destroy' do
    let(:do_request) { delete :destroy, params: { id: question } }
    before { question }

    context 'Author tries delete question' do
      before { sign_in user }

      it 'deletes question' do
        expect { do_request }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        do_request
        expect(response).to redirect_to questions_path
      end
    end

    let(:model) { Question }
    it_behaves_like 'Deletable'
  end
end
