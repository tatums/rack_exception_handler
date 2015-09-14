require_relative "email/config"

module RackExceptionHandler
  module Plugins

    module Email

      EMAIL_TEMPLATE = File.expand_path("../email/email.erb", __FILE__)

      def self.call exception, options={}
        if valid?
          configure!

          user_message = options.fetch(:user_message, "")

          erb = ERB.new(File.read(EMAIL_TEMPLATE))
          email_body = erb.result binding

          mail = Mail.new do
            from Plugins::Email.config.from
            to  Plugins::Email.config.to
            subject Plugins::Email.config.subject
            body email_body
          end
          mail.deliver!
        end
      end

      def self.config
        @config ||= Config.new
      end

      def self.configure
        yield(config)
      end

      private

      def self.valid?
        !Plugins::Email.config.from.nil? &&
          !Plugins::Email.config.to.nil?
      end

      def self.configure!
        Mail.defaults do
          delivery_method Plugins::Email.config.delivery_method, {
            address:        Plugins::Email.config.address,
            port:           Plugins::Email.config.port,
            authentication: Plugins::Email.config.authentication,
            user_name:      Plugins::Email.config.user_name,
            password:       Plugins::Email.config.password,
            enable_starttls_auto: true
          }
        end
      end


    end

  end
end
