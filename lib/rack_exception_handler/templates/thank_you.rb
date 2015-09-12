module RackExceptionHandler
  module Templates
    class ThankYou

      ERROR_TEMPLATE = File.expand_path("../thank_you.erb", __FILE__)

      def self.html
        erb = ERB.new(File.read(ERROR_TEMPLATE))
        erb.result binding
      end

    end

  end
end
