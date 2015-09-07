require 'spec_helper'

describe RackExceptionHandler do
  it 'has a version number' do
    expect(RackExceptionHandler::VERSION).not_to be nil
  end
  context "config" do
    it {
      expect(RackExceptionHandler.config.port).to eq(25)
    }
    it "allow you to overrite the port" do
      RackExceptionHandler.configure { |c| c.port = 123 }
      expect(RackExceptionHandler.config.port).to eq(123)
    end
  end
end
