module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down cancel_vote]
  end

  def vote_up
    @vote = current_user.vote(@votable, 1)
    vote_respond(@vote)
  end

  def vote_down
    @vote = current_user.vote(@votable, -1)
    vote_respond(@vote)
  end

  def cancel_vote
    @votable.votes.where(user: current_user).destroy_all
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def vote_respond(vote)
    if vote
      respond_to do |format|
        format.json { render json: vote }
      end
    end
  end
end
