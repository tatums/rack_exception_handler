module RackExceptionHandler
  class Middleware

    attr_reader :request

    def initialize(app)
      @app = app
    end

    def call(env)
      begin

        @request = Rack::Request.new(env)
        if fire_notifications?
          ## FIXME - impedience mismatch
          user_message  = request.params["message"]
          exception     = JsonParser.from_json_to_exception(request.params["exception"])
          request.session["rack_exception"] = nil
          RackExceptionHandler.plugins.each do |plugin|
            plugin.call(exception, user_message: user_message)
          end
          [200, {"Content-Type" => "text/html"}, [ Templates::ThankYou.html ] ]
        else
          @app.call(env)
        end

      rescue => e

        if RackExceptionHandler.plugins.any?
          request.session["rack_exception"] = true
          content = JsonParser.as_json(e)
          [200, {"Content-Type" => "text/html"}, [ Templates::Error.html(content) ] ]
        else
          @app.call(env)
        end

      end
    end

    private

    def fire_notifications?
      request.post? && request.session["rack_exception"] && request.params["exception"] && request.params["message"]
    end


  end
end
