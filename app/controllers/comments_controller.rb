class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.json { render json: { comment: @comment } }
      else
        format.json { render json: { errors: @comment.errors } }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if current_user.author_of?(@comment)
      respond_to do |format|
        format.json { render json: { comment_id: @comment.destroy.id } }
      end
    end
  end

  private

  def load_commentable
    klass = [Question, Answer].detect {|c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id

    ActionCable.server.broadcast("comments #{question_id}", comment: @comment)
  end
end
