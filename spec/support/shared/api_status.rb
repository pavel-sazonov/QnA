shared_examples_for "API successfulable" do
  it "returns 200 status" do
    expect(response).to be_successful
  end
end
