module RackExceptionHandler
  module Plugins
    module Slack
      class NoOpClient

        def self.post uri, params={}
        end

      end
    end
  end
end
