class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  include Voted
  respond_to :js, only: :update
  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @subscription = @question.subscriptions.find_by(user: current_user)
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[id file _destroy])
  end

  def build_answer
    @answer = @question.answers.new
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_for_index',
        locals: { question: @question }
      )
    )
  end
end
