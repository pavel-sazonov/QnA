module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down cancel_vote]
  end

  def vote_up
    @vote = current_user.vote(@votable, 1)
    votable_raiting
  end

  def vote_down
    @vote = current_user.vote(@votable, -1)
    votable_raiting
  end

  def cancel_vote
    @votable.voted_by(current_user).destroy_all
    votable_raiting
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def votable_raiting
    respond_to do |format|
      format.json { render json: { raiting: @votable.raiting, votable_id: @votable.id } }
    end
  end
end
