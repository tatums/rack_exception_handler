module RackExceptionHandler
  class Railtie < Rails::Railtie
   initializer "rack_exception_handler.configure_rails_initialization" do |app|
      app.middleware.use RackExceptionHandler::Middleware
    end
  end
end


