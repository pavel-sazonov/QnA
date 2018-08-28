class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_subscription, only: :destroy

  def create
    authorize! :subscribe, @question
    @subscription = @question.subscriptions.create(user: current_user)
    redirect_to @question, notice: 'Subscribed'
  end

  def destroy
    authorize! :destroy, @subscription
    @subscription.destroy
    redirect_to @subscription.question, notice: 'Unsubscribed'
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end
