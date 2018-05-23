class FileUploader < CarrierWave::Uploader::Base
  delegate :identifier, to: :file

  storage :file

  def store_dir
    "uploads/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
