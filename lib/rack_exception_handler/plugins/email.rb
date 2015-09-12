module RackExceptionHandler
  module Plugins
    class Email

      EMAIL_TEMPLATE = File.expand_path("../email.erb", __FILE__)

      def self.configure!
        Mail.defaults do
          delivery_method RackExceptionHandler.config.delivery_method, {
            address:        RackExceptionHandler.config.address,
            port:           RackExceptionHandler.config.port,
            authentication: RackExceptionHandler.config.authentication,
            user_name:      RackExceptionHandler.config.user_name,
            password:       RackExceptionHandler.config.password,
            enable_starttls_auto: true
          }
        end
      end

      def self.plugin
        configure!
        Proc.new do |exception, options={}|

          message = options.fetch(:message, "")

          ## This can be extracted into some sort of exception parser
          body_lines = exception.split('\n')
          erb = ERB.new(File.read(EMAIL_TEMPLATE))
          email_body = erb.result binding

          mail = Mail.new do
            from RackExceptionHandler.config.from
            to  RackExceptionHandler.config.to
            subject RackExceptionHandler.config.subject
            body email_body
          end

          mail.deliver!
        end

      end

    end

  end
end
