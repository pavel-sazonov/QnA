require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it do
    should validate_length_of(:title).
    is_at_least(5).is_at_most(50)
  end

  it do
    should validate_length_of(:body).
    is_at_least(5)
  end

  it { should have_db_index(:user_id) }
  it { should accept_nested_attributes_for :attachments }
end
