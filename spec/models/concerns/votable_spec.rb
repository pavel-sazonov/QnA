require "rails_helper"

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:users) { create_list(:user, 2) }
  let!(:vote_one) { create(:vote, user: users.first, votable: question, value: 1) }
  let!(:vote_two) { create(:vote, user: users.last, votable: question, value: 1) }

  it "#raiting" do
    expect(question.raiting).to eq 2
  end

  it "#voted_by" do
    expect(question.voted_by(users.first).size).to eq 1
  end
end

describe Question, type: :model do
  it_behaves_like 'votable'
end

describe Answer, type: :model do
  it_behaves_like 'votable'
end
