# RackExceptionHandler

Rescue an exception and present the user with a form where they can
explain what they were doing when the exception occured. The results 
are then sent *with a stack trace*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack_exception_handler'
```

## Usage

### Rails

In config/environments/*.rb

Here the email AND the slack plugin are setup

```ruby

   RackExceptionHandler::Plugins::Email.configure do |config|
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

    RackExceptionHandler::Plugins::Slack.configure do |config|
      config.web_hook = "https://hooks.slack.com/services/GODF23/ABSSDFD/1223345"
    end

```

### Rack
## TODO

### Plugins
https://github.com/tatums/rack_exception_handler/tree/master/lib/rack_exception_handler/plugins


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack_exception_handler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
