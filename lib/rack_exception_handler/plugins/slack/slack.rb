module RackExceptionHandler
  module Plugins
    module Slack

      class Slack

        def self.plugin
          if valid?
            Proc.new do |exception, options={}|

              user_message = options.fetch(:user_message, "")

              notifier = ::Slack::Notifier.new Plugins::Slack.config.web_hook,
                http_client: Plugins::Slack.config.http_client,
                username: "RackExceptionHandler",
                icon_emoji: ":space_invader:"

              notifier.ping "user_message:\n#{user_message}\n\n```#{exception.message}```\n```#{exception.backtrace.join("\n")}```"

            end
          end
        end

        private

        def self.valid?
          !Plugins::Slack.config.web_hook.nil?
        end
      end

    end
  end
end
