require "slack-notifier"
require_relative "slack/config"
require_relative "slack/client"
require_relative "slack/no_op_client"

module RackExceptionHandler
  module Plugins
    module Slack

      def self.config
        @config ||= Config.new
      end

      def self.configure
        yield(config)
      end

      def self.call exception, options={}
        if valid?
          user_message = options.fetch(:user_message, "")
          notifier = ::Slack::Notifier.new Plugins::Slack.config.web_hook,
            http_client: Plugins::Slack.config.http_client,
            username: "RackExceptionHandler",
            icon_emoji: ":space_invader:"
          notifier.ping "user_message:\n#{user_message}\n\n```#{exception.message}```\n```#{exception.backtrace.join("\n")}```"
        end
      end

      private

      def self.valid?
        !Plugins::Slack.config.web_hook.nil?
      end

    end

  end
end
