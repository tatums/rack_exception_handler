require 'spec_helper'

describe RackExceptionHandler::Plugins::Email do
  context "config" do
    it {
      expect(RackExceptionHandler::Plugins::Email.config.port).to eq(25)
    }
    it "allow you to overrite the port" do
      RackExceptionHandler::Plugins::Email.configure { |c| c.port = 123 }
      expect(RackExceptionHandler::Plugins::Email.config.port).to eq(123)
    end
  end
end
