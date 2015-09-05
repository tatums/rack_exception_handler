module RackExceptionHandler
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue => e
        [200, {"Content-Type" => "text/html"}, [ html(e) ] ]
      end
    end

    private

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
