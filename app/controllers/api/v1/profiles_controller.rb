class Api::V1::ProfilesController < ApplicationController
  skip_authorization_check
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def other_users
    respond_with noncurrent_resource_owners
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def noncurrent_resource_owners
    @noncurrent_resource_owners ||= User.where.not('id = ?', doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
