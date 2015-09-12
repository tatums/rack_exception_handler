require "rack"
require "mail"
require "rack_exception_handler/version"
require "rack_exception_handler/middleware"
require "rack_exception_handler/templates/error"
require "rack_exception_handler/templates/thank_you"

## TODO conditionalize these??
require "rack_exception_handler/plugins/email"
require "rack_exception_handler/plugins/slack"
require "slack-notifier"

module RackExceptionHandler
  def self.plugins
    [
      Plugins::Email::Email.plugin,
      Plugins::Slack::Slack.plugin
    ].compact
  end
end

require 'rack_exception_handler/railtie' if defined?(Rails)
