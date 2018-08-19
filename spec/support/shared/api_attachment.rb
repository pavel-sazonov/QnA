shared_examples_for "API Attachable" do
  context 'attachments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path("#{path_resource}/attachments")
    end

    it 'contains file_url' do
      expect(response.body)
        .to be_json_eql(attachment.file.url.to_json)
        .at_path("#{path_resource}/attachments/0/file_url")
    end
  end
end
