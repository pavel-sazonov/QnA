require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe 'GitHub' do
    let(:user) { create :user }
    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'Success handling' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '123456',
          info: { email: user.email }
        )
        get :github
      end

      it 'should set :notice flash' do
        expect(flash[:notice]).to eq "Successfully authenticated from github account."
      end

      it 'should set current_user to proper user' do
        expect(subject.current_user).to eq(user)
      end
    end
  end
end
