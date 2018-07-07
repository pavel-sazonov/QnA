require "rails_helper"

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users[0]) }
  let!(:vote_one) { create(:vote, user: users[1], votable: question, value: 1) }
  let!(:vote_two) { create(:vote, user: users[2], votable: question, value: 1) }

  it "#rating" do
    expect(question.rating).to eq 2
  end

  it "#voted_by" do
    expect(question.voted_by(users[1]).size).to eq 1
  end
end
