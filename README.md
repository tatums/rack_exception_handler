# RackExceptionHandler

Rescue an exception and present the user with a form where they can
input info then email the results *with a stack trace*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack_exception_handler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack_exception_handler

## Usage

### Rails

In config/application.rb OR config/environments/*.rb

```ruby
   RackExceptionHandler.configure do |config|

      config.from = "no-reply@example.com"
      config.to = "someone.who.cares@example.com"
      config.subject = "Exception"

      config.delivery_method = :smtp
      config.authentication = "login"
      config.user_name = "tatum@example.com"
      config.password = "tooManySecrets"
      config.address = "smtp.gmail.com"
      config.port = 587
    end
```


TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack_exception_handler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
