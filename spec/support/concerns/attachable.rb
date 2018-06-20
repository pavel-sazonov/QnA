require "rails_helper"

shared_examples_for "attachable" do
  it { should have_many(:attachments).dependent(:destroy) }
end
