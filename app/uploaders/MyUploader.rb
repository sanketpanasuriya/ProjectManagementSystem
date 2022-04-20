class MyUploader < CarrierWave::Uploader::Base
    def content_type_allowlist
      /image\//
    end
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end