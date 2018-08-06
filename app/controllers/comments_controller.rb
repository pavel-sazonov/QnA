class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  after_action :publish_comment, only: :create

  respond_to :json, only: :create
  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def destroy
    @comment = Comment.find(params[:id])
    comment_id = @comment.id
    # почему-то тут не срабатывает без дополнительного if can?
    @comment.destroy if can? :destroy, @comment

    respond_to do |format|
      format.json { render json: { comment_id: comment_id } }
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
