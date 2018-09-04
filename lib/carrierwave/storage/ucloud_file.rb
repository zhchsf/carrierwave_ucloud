module CarrierWave
  module Storage
    class UcloudFile < CarrierWave::SanitizedFile
      attr_reader :path, :bucket

      def initialize(uploader, base, path)
        @uploader = uploader
        @path     = path
        @base     = base
        @bucket   = ::CarrierWave::Ucloud::Bucket.new(uploader)
      end

      def read
        response = bucket.get(path)
        @headers = response.headers.deep_transform_keys { |k| k.underscore.to_sym rescue key }
        response.body
      end

      def delete
        bucket.delete(path)
      end

      def url
        bucket.url(path)
      end

      def store(file, headers = {})
        bucket.put(path, file, headers)
      end

      def content_type
        headers[:content_type]
      end

      def content_type=(new_content_type)
        headers[:content_type] = new_content_type
      end

      def headers
        @headers ||= {}
      end
    end
  end
end
