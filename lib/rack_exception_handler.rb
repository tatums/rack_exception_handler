require "rack"
require "mail"
require "rack_exception_handler/version"
require "rack_exception_handler/middleware"
require "rack_exception_handler/json_parser"
require "rack_exception_handler/templates/error"
require "rack_exception_handler/templates/thank_you"

## TODO conditionalize these??
# Dir.glob("./lib/rack_exception_handler/plugins/*.rb").map {|path| require path }
require "rack_exception_handler/plugins/email"
require "rack_exception_handler/plugins/slack"

module RackExceptionHandler
  def self.plugins
    RackExceptionHandler::Plugins.constants.map do |constant|
      "RackExceptionHandler::Plugins::#{constant}".constantize
    end
  end
end

require 'rack_exception_handler/railtie' if defined?(Rails)
