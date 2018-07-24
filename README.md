# BingAdsSimpleApi

Bing's SOAP API is a complicated and powerful beast with a steep learning curve that allows you access to everything in Bing. There's no official Ruby SDK so if you're working in Ruby you have to mess directly with SOAP. This gem is neither powerful nor complete, far from both, but is instead provides access to a handful of the most common tasks with a very simple ruby like interface.

This gem is very alpha. You probably don't want to use it unless you're actively developing it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bing-ads-simple-api', {
  git: 'https://github.com/goldstar/bing-ads-simple-api.git',
  ref: 'master'
}
```

Since this gem's interface can change at anytime, it's recommended that you point to a specific commit and not master.

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bing-ads-simple-api

## Usage

### Configuration

```ruby
require 'bing_ads_simple_api'

BingAdsSimpleApi.authentication = {
  client_id:           '00000000-0000-0000-0000-000000000000', # register your app with microsoft to get an id for your app/client
  customer_account_id: '00000000', # get this from the URLs of the bing web UI
  customer_id: '0000000', # get this from the URLs of the bing web UI
  authentication_token: '....',  # Oauth access_token, ignored if using a refresh token
  refresh_token: '...' # fetches a new authentication_token as needed
}
```

Access tokens expire after 60 minutes.  Alternatively, you can pass in a `refresh_token` and a new access_token will be fetched as needed. This refresh token will last 90 days. Use the script `ruby bing_auth_token.rb` to generate a refresh token. See the Bing API documentation for more details on [configuring authentication](https://docs.microsoft.com/en-us/bingads/guides/authentication-oauth?view=bingads-12#authorizationcode).

### Reporting

Some predefined ready to run reports are `lib/bing_ads_simple_api/reports`. You can use them as examples to create your own.

```ruby
  BingAdsSimpleApi::Reports::DailyAdPerformanceReport.new().to_a # returns an array of hashes for each ad that ran yesterday
  BingAdsSimpleApi::Reports::DailyAdPerformanceReport.new(Date.new(2018,1,1)).to_a # returns an array of hashes for each ad that ran on Jan 1
  BingAdsSimpleApi::Reports::DailyAdPerformanceReport.new(Date.new(2018,1,1)..Date.new(2018,1,31)).to_a # returns an array of hashes for each ad that ran during the time range
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldstar/bing-ads-simple-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
