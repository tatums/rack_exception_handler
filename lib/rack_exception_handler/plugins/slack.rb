require_relative "slack/slack"
require_relative "slack/client"
require_relative "slack/no_op_client"

module RackExceptionHandler
  module Plugins

    module Slack
      class Config
        attr_accessor :web_hook, :http_client

        def initialize
          @http_client = Client
        end
      end
    end

    module Slack
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
