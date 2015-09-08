module RackExceptionHandler
  class Middleware

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
        <style type="text/css">

          .hidden{
            visibility:hidden;
            float:left;
          }

          body{ padding: 0 2em; }

          .textarea {
              display: block;
              width: 100%;
              height: 300px;
              font-size: 14px;
              line-height: 1.42857143;
              color: #555;
              background-color: #fff;
              background-image: none;
              border: 1px solid #ccc;
              border-radius: 4px;
              -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
              box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
              -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
              -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
              transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
          }

          .button {
              float:right;
              color: #fff;
              background-color: #3386A7;
              border-color: #2e6da4;
              display: inline-block;
              padding: 6px 12px;
              margin-bottom: 0;
              font-size: 14px;
              font-weight: 400;
              line-height: 1.42857143;
              text-align: center;
              white-space: nowrap;
              vertical-align: middle;
              -ms-touch-action: manipulation;
              touch-action: manipulation;
              cursor: pointer;
              -webkit-user-select: none;
              -moz-user-select: none;
              -ms-user-select: none;
              user-select: none;
              background-image: none;
              border: 1px solid transparent;
              border-radius: 4px;
          }


        </style>
      </head>
      HEAD
    end

    def body(e)
      <<-BODY
      <body>

        <form method='post'>
          <h1>Uh oh! Sorry, but something has gone wrong.</h1>
          <p>Please take a moment and tell us what you were doing.</p>
          <textarea class='textarea' style='visiblity:hidden;' name='message'></textarea>
          <textarea class='hidden' name='exception'>#{e.backtrace.join('\n')}</textarea>
          <input class='button' type='submit' value='Send'>
        </form>

<!--
        <h1>ERROR: #{e}</h1>
        <ul>
        #{
            e.backtrace.map do |line|
              "<li>#{line}</li>"
            end.join
        }
        </ul>
-->
      </body>
      BODY
    end

  end
end
