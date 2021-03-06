require 'rails_helper'

describe 'Question API' do
  let(:question) { create :question }
  let!(:answers) { create_list :answer, 2, question: question }
  let(:answer) { answers.first }
  let(:access_token) { create :access_token }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      it_behaves_like 'API successfulable'

      before { do_request access_token: access_token.token }

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body)
            .to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:comment) { create :comment, commentable: answer }
      let!(:attachment) { create :attachment, attachable: answer }
      let(:path_resource) { 'answer' }

      before { do_request access_token: access_token.token }

      it_behaves_like 'API successfulable'

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body)
            .to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        before { do_request answer: attributes_for(:answer), access_token: access_token.token }

        it 'returns 201 status' do
          expect(response.status).to eq 201
        end

        %w[id body created_at updated_at].each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body)
              .to be_json_eql(Answer.all.last.send(attr.to_sym).to_json).at_path("answer/#{attr}")
          end
        end
      end

      context 'with invalid attributes' do
        before { do_request answer: attributes_for(:invalid_answer), access_token: access_token.token }

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end

        it 'returns errors json' do
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0')
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
