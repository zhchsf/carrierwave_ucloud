require 'carrierwave_ucloud/version'
require 'carrierwave/storage/ucloud'
require 'carrierwave/storage/ucloud_file'
require 'carrierwave/ucloud/bucket'
require 'carrierwave/ucloud/configuration'

CarrierWave::Uploader::Base.send(:include, CarrierWave::Ucloud::Configuration)

module CarrierwaveUcloud
  # Your code goes here...
end
