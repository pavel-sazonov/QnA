require 'rails_helper'

describe 'Question API' do
  let(:access_token) { create :access_token }
  let!(:questions) { create_list :question, 2 }
  let(:question) { questions.first }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:answer) { create :answer, question: question }

      before { do_request access_token: access_token.token }

      it_behaves_like 'API successfulable'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body)
            .to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body)
          .to be_json_eql(question.title.truncate(10).to_json).at_path 'questions/0/short_title'
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body)
              .to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:comment) { create :comment, commentable: question }
      let!(:attachment) { create :attachment, attachable: question }
      let(:path_resource) { 'question' }

      before { do_request access_token: access_token.token }

      it_behaves_like 'API successfulable'

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body)
            .to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized with valid attributes' do
      before { do_request question: attributes_for(:question), access_token: access_token.token }

      it 'returns 201 status' do
        expect(response.status).to eq 201
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body)
            .to be_json_eql(Question.all.last.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end

    context 'authorized with invalid attributes' do
      before { do_request question: attributes_for(:invalid_question), access_token: access_token.token }

      it 'returns 422 status' do
        expect(response.status).to eq 422
      end

      it 'returns errors json' do
        expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/title/0')
        expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0')
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end
end
