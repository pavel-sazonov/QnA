require "rails_helper"

shared_examples_for "attachable" do
  it { should have_many(:attachments).dependent(:destroy) }
end

describe Question, type: :model do
  it_behaves_like 'attachable'
end

describe Answer, type: :model do
  it_behaves_like 'attachable'
end
