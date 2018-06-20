module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down cancel_vote]
  end

  def vote_up
    @vote = current_user.vote(@votable, 1)
    respond_json
  end

  def vote_down
    @vote = current_user.vote(@votable, -1)
    respond_json
  end

  def cancel_vote
    @votable.voted_by(current_user).destroy_all
    respond_json
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def respond_json
    respond_to do |format|
      format.json { render json: { rating: @votable.rating, votable_id: @votable.id } }
    end
  end
end
