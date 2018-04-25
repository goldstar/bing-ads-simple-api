# BingSimpleApi

Bing's SOAP API is a complicated and powerful beast with a steep learning curve that allows you access to everything in Bing. There's no official Ruby SDK so if you're working in Ruby you have to mess directly with SOAP. This gem is neither powerful nor complete, far from both, but is instead provides access to a handful of the most common tasks with a very simple ruby like interface.

This gem is very alpha. You probably don't want to use it unless you're actively developing it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bing-simple-api', {
  git: 'https://github.com/goldstar/bing-simple-api.git',
  ref: 'master'
}
```

Since this gem's interface can change at anytime, it's recommended that you point to a specific commit and not master.

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bing-simple-api

## Usage

### Congifiguration

```ruby
require 'bing_simple_api'

BingSimpleApi.bing_authentication = {

}

```

See the Bing API documentation on the configuring authentication.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldstar/bing-simple-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
