module RackExceptionHandler
  module Templates
    class Error

      ERROR_TEMPLATE = File.expand_path("../error.erb", __FILE__)

      def self.html(exception)
        erb = ERB.new(File.read(ERROR_TEMPLATE))
        erb.result binding
      end
    end
  end
end
