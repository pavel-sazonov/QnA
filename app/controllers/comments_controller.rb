class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save

    respond_to do |format|
      format.json { render json: {
        comment_id: @comment.id,
        comment_body: @comment.body,
        commentable_class_name: @commentable.class.name.underscore
      } }
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
end
