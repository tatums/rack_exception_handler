require 'spec_helper'

describe RackExceptionHandler::Plugins::Slack do
  context "config" do
    it "allow you to configure" do
      RackExceptionHandler::Plugins::Slack.configure { |c| c.web_hook = "blah123" }
      expect(RackExceptionHandler::Plugins::Slack.config.web_hook).to eq "blah123"
    end
  end
end
