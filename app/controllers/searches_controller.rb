class SearchesController < ApplicationController
  respond_to :js, only: :result

  def result
    authorize! :do, :search

    return render :show if params[:q].empty?

    model = params[:model].constantize
    respond_with(@result = model.search(params[:q], { per_page: 20, order: 'created_at DESC' }))
  end

  def show
    authorize! :do, :search
  end
end
