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

    # не разобрался, как выполнить условие, чтобы User.find_for_oauth возвращал non-persited user
    context 'Non-persisting User' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '123456',
          info: { email: "" }
          # выкидывается исключение, тк в User.find_for_oauth вызывается User.create!
          # если сделать без !, то в User.find_for_oauth не создастся авторизация для non-persisted user
        )
        get :github
      end

      it 'should redirect to new user registration' do
        expect(response).to redirect_to new_user_registration_path
      end

      it 'should set flash :notice' do
        expect(flash[:notice]).to exist
      end
    end
  end
end
