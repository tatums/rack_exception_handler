module RackExceptionHandler
  class Middleware

    ERROR_TEMPLATE = File.expand_path("../templates/error.erb", __FILE__)
    EMAIL_TEMPLATE = File.expand_path("../templates/email.erb", __FILE__)

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        request = Rack::Request.new(env)
        if request.post? && request.session["rack_exception"] && request.params["exception"] && request.params["message"]
          request.session["rack_exception"] = nil
          send_mail(request.params)
          [200, {"Content-Type" => "text/html"}, [ "Thank you" ] ]
        else
          @app.call(env)
        end
      rescue => e
        request.session["rack_exception"] = true
        [200, {"Content-Type" => "text/html"}, [ error_html(e) ] ]
      end
    end

    private

    def send_mail(params)
      message = params["message"]
      exception = params["exception"]

      ## TODO - come up with a better way to pass options
      Mail.defaults do
        delivery_method RackExceptionHandler.config.delivery_method, {address:        RackExceptionHandler.config.address,
                                port:           RackExceptionHandler.config.port,
                                authentication: RackExceptionHandler.config.authentication,
                                user_name:      RackExceptionHandler.config.user_name,
                                password:       RackExceptionHandler.config.password}
      end

      body = email_body(message, exception)
      Mail.new do
        from RackExceptionHandler.config.from
        to  RackExceptionHandler.config.to
        subject RackExceptionHandler.config.subject
        body body
      end.deliver
    end

    def email_body(message, exception)
      body_lines = exception.split('\n')
      erb = ERB.new(File.read(EMAIL_TEMPLATE))
      erb.result binding
    end

    def error_html(e)
      body = e.backtrace.join('\n')
      erb = ERB.new(File.read(ERROR_TEMPLATE))
      erb.result binding
    end

  end
end
