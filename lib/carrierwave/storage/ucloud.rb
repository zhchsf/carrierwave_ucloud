require 'carrierwave'

module CarrierWave
  module Storage
    class Ucloud < Abstract
      def store!(file)
        f = UcloudFile.new(uploader, self, uploader.store_path)
        f.store(file, 'Content-Type' => file.content_type)
        f
      end

      def retrieve!(identifier)
        UcloudFile.new(uploader, self, uploader.store_path(identifier))
      end
    end
  end
end
