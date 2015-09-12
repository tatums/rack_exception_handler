module RackExceptionHandler
  class Middleware

    attr_reader :request

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @request = Rack::Request.new(env)
        message = request.params["message"]
        exception = request.params["exception"]

        if fire_notifications?
          request.session["rack_exception"] = nil

          RackExceptionHandler.plugins.each do |plugin|
            plugin.call(exception, message: message)
          end

          [200, {"Content-Type" => "text/html"}, [ "Thank you" ] ]
        else
          @app.call(env)
        end
      rescue => e
        request.session["rack_exception"] = true
        [200, {"Content-Type" => "text/html"}, [ ErrorTemplate.html(e) ] ]
      end
    end

    private

    def fire_notifications?
      request.post? && request.session["rack_exception"] && request.params["exception"] && request.params["message"]
    end


  end
end
