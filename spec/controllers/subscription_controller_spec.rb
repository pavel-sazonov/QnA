require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create :user }

  describe 'POST #create' do
    let!(:question) { create :question }
    let(:do_request) { post :create, params: { question_id: question } }

    context 'guest' do
      it 'does not create a new subscription in the database' do
        puts "===#{Subscription.all.count}"
        expect { do_request }.to_not change(Subscription, :count)
      end
    end

    context 'authenticated user' do
      before { sign_in user }

      it 'saves a new question subscription in the database' do
        expect { do_request }.to change(question.subscriptions, :count).by(1)
      end

      it 'saves a new user subscription in the database' do
        expect { do_request }.to change(user.subscriptions, :count).by(1)
      end

      it 'redirects to question show view' do
        do_request
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create :subscription, user: user }
    let(:do_request) { delete :destroy, params: { id: subscription } }

    context 'Subscribed user' do
      before { sign_in(user) }

      it 'deletes subscription' do
        expect { do_request }
          .to change(user.subscriptions, :count).by(-1)
      end

      it 'redirects to question show view' do
        do_request
        expect(response).to redirect_to question_path(subscription.question)
      end
    end

    let(:another_user) { create :user }
    let(:model) { Subscription }
    it_behaves_like 'Deletable'
  end
end
