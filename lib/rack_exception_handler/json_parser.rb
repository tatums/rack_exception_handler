module RackExceptionHandler
  class JsonParser

    attr_accessor :message, :backtrace

    def initialize(message, backtrace)
      @message = message
      @backtrace = backtrace
    end

    def self.as_json(exception)
      JSON.generate(
        {
          message: exception.message,
          backtrace: exception.backtrace
        }
      )
    end

    def self.from_json_to_exception(json)
      hash = JSON.parse(json)
      new(hash["message"], hash["backtrace"])
    end
  end
end
