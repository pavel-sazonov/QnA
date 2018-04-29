require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
  it do
    should validate_length_of(:body).
    is_at_least(5)
  end
  it { should have_db_index(:user_id) }
  it { should have_db_index(:question_id) }
end
