module Attachable
  extend ActiveSupport::Concern

  include Authorable

  included do
    has_many :attachments, as: :attachable, dependent: :destroy
  end
end
