require 'rails_helper'

describe 'Profile API' do
  let(:me) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: me.id }

  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { do_request access_token: access_token.token }

      it_behaves_like 'API successfulable'

      %w[email id created_at updated_at].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:users) { create_list :user, 3 }

      before { do_request access_token: access_token.token }

      it_behaves_like 'API successfulable'

      it 'returns json with 3 users' do
        expect(response.body).to have_json_size 3
      end

      %w[email id created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          user = users.first
          expect(response.body)
            .to be_json_eql(user.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'other users do not include me' do
        users.each_index do |i|
          expect(response.body)
            .to_not be_json_eql(me.email.to_json).at_path("#{i}/email")
        end
      end

      %w[password encrypted_password].each do |attr|
        it "each user does not contain #{attr}" do
          users.each_index do |i|
            expect(response.body)
              .to_not be_json_eql(me.send(attr.to_sym).to_json).at_path(i.to_s)
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end
