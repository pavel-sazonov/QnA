shared_examples_for "Voted action" do
  it 'change user votes in the database' do
    expect { request }
      .to change(user.votes, :count).by(changed_users_votes_count)
  end

  it "response with success" do
    request
    expect(response).to be_successful
  end

  it "response with proper json" do
    request
    expect(response.body).to eq "{\"rating\":#{rating},\"votable_id\":#{votable.id}}"
  end
end
