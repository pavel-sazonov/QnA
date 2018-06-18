require "rails_helper"

shared_examples_for "authorable" do
  it { should belong_to(:user) }
end

describe Question, type: :model do
  it_behaves_like 'authorable'
end

describe Answer, type: :model do
  it_behaves_like 'authorable'
end
