# CarrierwaveUcloud

Ucloud Ufile CarrierWave Gem。

参考了aws/aliyun/ucloud多个已有CarrierWave插件的代码，感谢他们的付出。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave_ucloud', '0.2.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave_ucloud

## Usage

配置文件：config/initializers/carrierwave.rb，内容如下：

```ruby
# public / private 最少配置一套，ucloud_public_read自己要对应好，暂时没有做任何校验逻辑
CarrierWave.configure do |config|
  config.storage = :ucloud
  config.ucloud_public_key = "public_key"
  config.ucloud_private_key = "private_key"
  config.ucloud_public_read = true # 默认使用public bucket，可在单个uploader覆写
  # public bucket配置
  config.ucloud_public_bucket = "public_bucket_name"
  config.ucloud_public_bucket_host = "http://public_bucket_name.cn-bj.ufileos.com"
  config.ucloud_public_cdn_host = "http://public_bucket_name.cn-bj.ufileos.com"
  config.ucloud_private_bucket = "private_bucket_name"
  # private bucket配置
  config.ucloud_private_bucket_host = "http://private_bucket_name.cn-bj.ufileos.com"
  config.ucloud_private_cdn_host = "http://private_bucket_name.cn-bj.ufileos.com"
  config.ucloud_private_expire_seconds = 300
end
```

全局配置ucloud_public_read，默认使用对应bucket配置，个别uploader如要用另外一种bucket配置，添加如下方法:
```ruby
class XxxUploader < CarrierWave::Uploader::Base
  storage :ucloud

  def ucloud_public_read
    # true or false，XxxUploader以此配置选择bucket配置及逻辑
  end
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/carrierwave_ucloud. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CarrierwaveUcloud project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/carrierwave_ucloud/blob/master/CODE_OF_CONDUCT.md).
