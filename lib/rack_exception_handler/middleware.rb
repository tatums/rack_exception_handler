module RackExceptionHandler
  class Middleware

    ERROR_TEMPLATE = File.expand_path("../templates/error.erb", __FILE__)

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        request = Rack::Request.new(env)

        if request.post? && request.session["rack_exception"] && request.params["exception"] && request.params["message"]
          request.session["rack_exception"] = nil

          message = request.params["message"]
          exception = request.params["exception"]

          RackExceptionHandler.plugins.each do |plugin|
            plugin.call(exception, message: message)
          end

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

    def error_html(e)
      body = e.backtrace.join('\n')
      erb = ERB.new(File.read(ERROR_TEMPLATE))
      erb.result binding
    end

  end
end
