module RackExceptionHandler
  module Plugins
    module Slack
      class Client

        def self.post uri, params={}
          Net::HTTP.post_form uri, params
        end

      end
    end
  end
end
