require_relative "email/email"

module RackExceptionHandler
  module Plugins

    module Email
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

    module Email
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

  end
end
