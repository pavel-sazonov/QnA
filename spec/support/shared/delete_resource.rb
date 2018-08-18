shared_examples_for "Deletable" do
  context 'Non-author tries delete resource' do
    it 'does not delete resource' do
      sign_in another_user
      expect { do_request }.to_not change(model, :count)
    end
  end

  context 'Non authenticate user tries delete resource' do
    it 'does not delete resource' do
      expect { do_request }.to_not change(model, :count)
    end
  end
end
