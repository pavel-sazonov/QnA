require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe 'GitHub' do
    context 'Success handling' do
      let(:user) { create :user }

      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
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

    # context 'Non-persisting User' do
    #   let(:non_persisted_user) { User.new() }

    #   before do
    #     request.env['devise.mapping'] = Devise.mappings[:non_persisted_user]

    #     # request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
    #     #   provider: 'github',
    #     #   uid: '123456',
    #     #   info: { email: "new@user.com" }
    #     # )
    #     User.stub(:find_for_oauth).and_return(:non_persisted_user)
    #     get :github
    #   end

    #   it 'should redirect to new user registration' do
    #     expect(response).to redirect_to new_user_registration_path
    #   end

    #   it 'should set flash :notice' do
    #     expect(flash[:notice]).to exist
    #   end
    # end
  end
end
