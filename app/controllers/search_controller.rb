class SearchController < ApplicationController
  skip_authorization_check

  def index
    @results = Question.search params[:q]
  end
end
