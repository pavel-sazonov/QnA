class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy set_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_best
    @question = @answer.question

    # первый вариант сброса старого лучшего ответа (вынести его в метод модели ответа)
    # old_best_answer = @question.answers.find_by(best: true)

    # if old_best_answer
    #   old_best_answer.update(best: false)
    # end

    # второй вариант
    @question.answers.update(best: false)

    @answer.update(best: true) if current_user.author_of?(@question)
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
