require 'base64'
require 'openssl'
require 'faraday'

module CarrierWave
  module Ucloud
    class Bucket
      PATH_PREFIX = %r{^/}

      def initialize(uploader)
        @ucloud_public_key             = uploader.ucloud_public_key
        @ucloud_private_key            = uploader.ucloud_private_key
        @ucloud_public_read            = uploader.ucloud_public_read
        @ucloud_bucket                 = @ucloud_public_read ? uploader.ucloud_public_bucket : uploader.ucloud_private_bucket
        @ucloud_bucket_host            = @ucloud_public_read ? uploader.ucloud_public_bucket_host : uploader.ucloud_private_bucket_host
        @ucloud_cdn_host               = @ucloud_public_read ? uploader.ucloud_public_cdn_host : uploader.ucloud_private_cdn_host
        @ucloud_private_expire_seconds = uploader.ucloud_private_expire_seconds || 300

        unless @ucloud_cdn_host.include?('//')
          raise "config.ucloud_cdn_host requirement include // http:// or https://, but you give: #{@ucloud_cdn_host}"
        end
      end

      # 上传文件
      def put(path, file, headers = {})
        path.sub!(PATH_PREFIX, '')

        response = conn.put(path, file.read) do |req|
          req.headers = headers
          token = authorization(req.method, headers['Content-Type'], path)
          req.headers['Authorization'] = token
        end

        if response.success?
          true
        else
          raise 'Ucloud上传失败'
        end
      end

      # 读取文件
      def get(path)
        path.sub!(PATH_PREFIX, '')
        response = conn.get(url(path))

        if response.success?
          return response
        else
          raise 'Ucloud Get File Fail'
        end
      end

      # 删除文件
      # @return [Boolean]
      def delete(path)
        path.sub!(PATH_PREFIX, '')
        response = conn.delete(url(path)) do |req|
          req.headers['Authorization'] = authorization(req.method, nil, path)
        end

        response.success?
      end

      # 查看文件是否存在（head response 200）
      # @return [Boolean]
      def exists?(path)
        path.sub!(PATH_PREFIX, '')
        response = conn.head(url(path)) do |req|
          req.headers['Authorization'] = authorization(req.method, nil, path)
        end

        response.success?
      end

      def url(path)
        if @ucloud_public_read
          public_get_url(path)
        else
          private_get_url(path)
        end
      end

      # 公开的访问地址
      def public_get_url(path)
        path.sub!(PATH_PREFIX, '')
        [@ucloud_cdn_host, path].join('/')
      end

      # 私有空间访问地址
      def private_get_url(path)
        public_get_url(path) + privite_get_url_auth(path)
      end

      private

      def conn
        @conn ||= begin
          Faraday.new(url: @ucloud_bucket_host) do |req|
            req.request :url_encoded
            req.adapter Faraday.default_adapter
          end
        end
      end

      # 私密查看url的认证信息
      def privite_get_url_auth(path)
        expired_ts = private_expire_ts
        signed_str = signature(string_to_sign('GET', nil, path, expired_ts))
        "?UCloudPublicKey=#{@ucloud_public_key}&Expires=#{expired_ts}&Signature=#{signed_str}"
      end

      def private_expire_ts
        @ucloud_private_expire_seconds + Time.now.to_i
      end

      def authorization(http_method, content_type, path)
        signed_str = signature(string_to_sign(http_method, content_type, path))
        "UCloud " + @ucloud_public_key + ":" + signed_str
      end

      def signature(str)
        Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', @ucloud_private_key, str))
      end

      def string_to_sign(http_method, ori_content_type, path, expired_ts = nil)
        http_verb = "#{http_method.upcase}\n"
        content_md5 = "\n"
        content_type = "#{ori_content_type}\n"
        timestamp = "#{expired_ts}\n"
        full_path = "/#{@ucloud_bucket}/#{path}"
        http_verb + content_md5 + content_type + timestamp + full_path
      end
    end
  end
end
