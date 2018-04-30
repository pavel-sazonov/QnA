class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :find_question, only: %i[index new create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    flash[:notice] = 'Your answer successfully created.' if @answer.save

    redirect_to @question
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer deleted.'
      redirect_to @answer.question
    else
      flash[:alarm] = 'You can not delete this answer.'
      redirect_to @answer.question
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
