class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy set_best]
  after_action :publish_answer, only: [:create]

  include Voted

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    gon.answer = @answer
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_best
    @question = @answer.question
    @answer.set_best if current_user.author_of?(@question)
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
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
