class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer deleted.'
    else
      flash[:alarm] = 'You can not delete this answer.'
    end

    redirect_to @answer.question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
