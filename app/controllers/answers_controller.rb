class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :find_question, only: %i[index new create]

  def index
    @answers = @question.answers
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    flash[:notice] = 'Your answer successfully created.' if @answer.save

    redirect_to @question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
