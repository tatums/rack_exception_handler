module RackExceptionHandler
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        request = Rack::Request.new(env)

        if request.post? && request.session[:rack_exception]
          request.session[:rack_exception] = nil

          send_mail(request.params)

          [200, {"Content-Type" => "text/html"}, [ "Thank you" ] ]
        else
          @app.call(env)
        end
      rescue => e
        request.session[:rack_exception] = true
        [200, {"Content-Type" => "text/html"}, [ html(e) ] ]
      end
    end

    private

    def send_mail(params)
      message = params["message"]
      exception = params["exception"]

      ## TODO - come up with a better way to pass options
      Mail.defaults do
        delivery_method :smtp, {address:        RackExceptionHandler.config.address,
                                port:           RackExceptionHandler.config.port,
                                authentication: RackExceptionHandler.config.authentication,
                                user_name:      RackExceptionHandler.config.user_name,
                                password:       RackExceptionHandler.config.password}
      end

      Mail.new do
        from RackExceptionHandler.config.from
        to  RackExceptionHandler.config.to
        subject RackExceptionHandler.config.subject
        body "message: #{message}, exception: #{exception}"
      end.deliver
    end

    def html(e)
      [
        "<!DOCTYPE html><html>",
        head,
        body(e),
        "</html>"
      ].join
    end

    def head
      <<-HEAD
      <head>
        <title>Rack App</title>
      </head>
      HEAD
    end

    def body(e)
      <<-BODY
      <body>

        <form method='POST'>
          <textarea name='message'></textarea>
          <textarea name='exception'>#{e.backtrace.join('\n')}</textarea>
          <input type='submit' value='Send'>
        </form>

        <h1>ERROR: #{e}</h1>
        <ul>
        #{
            e.backtrace.map do |line|
              "<li>#{line}</li>"
            end.join
        }
        </ul>
      </body>
      BODY
    end

  end
end
