require "rack"
require "mail"
require "rack_exception_handler/version"
require "rack_exception_handler/middleware"

require "rack_exception_handler/plugins/email"

module RackExceptionHandler
  class Config
    attr_accessor :address,
                  :delivery_method,
                  :port,
                  :authentication,
                  :user_name,
                  :password,
                  :from,
                  :to,
                  :subject

    def initialize
      @delivery_method = :smpt
      @port = 25
      @authentication = :login
      @subject = "An exception has occurred"
    end

  end
end


module RackExceptionHandler
  class << self
    attr_writer :configuration
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end
end

module RackExceptionHandler
  def self.plugins
    [
      Plugins::Email.plugin
    ]
  end
end

require 'rack_exception_handler/railtie' if defined?(Rails)
