require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :question_id }
  it do
    should validate_length_of(:body).
    is_at_least(30)
  end
end
