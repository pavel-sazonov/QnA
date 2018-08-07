require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :gon_user

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { errors: exception.message }, status: :forbidden }
      format.js { head :forbidden }
      format.html { flash[:alert] = exception.message }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
