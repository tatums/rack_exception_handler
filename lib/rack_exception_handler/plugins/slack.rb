require_relative "slack/slack"

module RackExceptionHandler
  module Plugins

    module Slack
      class Config
        attr_accessor :web_hook
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
