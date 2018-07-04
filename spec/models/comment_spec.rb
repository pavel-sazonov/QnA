require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }

  it { should validate_presence_of :body }

  it do
    should validate_length_of(:body).is_at_least(5)
  end
end
