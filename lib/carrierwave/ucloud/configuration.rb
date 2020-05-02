module CarrierWave
  module Ucloud
    module Configuration
      extend ActiveSupport::Concern

      included do
        add_config :ucloud_public_key
        add_config :ucloud_private_key
        # 是否使用公开url读取（其实跟设置的bucket是否私密有关），需要手工指定，可在Uploader覆写
        add_config :ucloud_public_read
        # 公开bucket的配置
        add_config :ucloud_public_bucket
        add_config :ucloud_public_bucket_host
        add_config :ucloud_public_cdn_host
        # 私有bucket的配置
        add_config :ucloud_private_bucket
        add_config :ucloud_private_bucket_host
        add_config :ucloud_private_cdn_host
        # 如果是私密的bucket，生成url的有效时间
        add_config :ucloud_private_expire_seconds

        configure do |config|
          config.storage_engines[:ucloud] = 'CarrierWave::Storage::Ucloud'
          config.cache_storage = :file
        end
      end
    end
  end
end
