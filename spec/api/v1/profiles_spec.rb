require 'rails_helper'

describe 'Profile API' do
  let(:me) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: me.id }

  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before do
        get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

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
  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:users) { create_list :user, 3 }

      before do
        get '/api/v1/profiles',
            params: { format: :json, access_token: access_token.token }
        @response_json = JSON.parse(response.body)
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns json with 3 users' do
        expect(response.body).to have_json_size 3
      end

      %w[email id created_at updated_at].each do |attr|
        it "each user contains #{attr}" do
          users.each_with_index do |user, i|
            expect(@response_json[i].to_json)
              .to be_json_eql(user.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      it "other users do not include me" do
        users.each_index do |i|
          expect(@response_json[i]['email'])
            .to_not eq me.email
        end
      end

      %w[password encrypted_password].each do |attr|
        it "each user does not contain #{attr}" do
          users.each_index do |i|
            expect(@response_json[i]).to_not eq me.send(attr.to_sym)
          end
        end
      end
    end
  end
end
