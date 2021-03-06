class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    attachable = @attachment.attachable

    @attachment.destroy if current_user.author_of?(attachable)
  end
end
