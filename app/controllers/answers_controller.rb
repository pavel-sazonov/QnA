class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy set_best]
  before_action :load_question, only: %i[create publish_answer]
  after_action :publish_answer, only: :create

  include Voted
  respond_to :js
  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    @question = @answer.question
    @answer.set_best
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[id file _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answers for question id: #{@question.id}",
      answer: @answer,
      attachments: @answer.attachments,
      rating: @answer.rating,
      question_user_id: @question.user_id
    )
  end
end
