module RackExceptionHandler
  module Plugins

    module Slack
      class Config
        attr_accessor :web_hook, :http_client
        def initialize
          @http_client = Client
        end
      end
    end

  end
end
