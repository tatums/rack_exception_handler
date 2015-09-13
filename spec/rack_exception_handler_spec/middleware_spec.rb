require 'spec_helper'
# NOTES
#
# Thse are acceptance tests
#
module RackExceptionHandler
  describe Middleware do

    before do
      RackExceptionHandler::Plugins::Email.configure { |c|
        c.delivery_method = :test
        c.from = "noRe@example.com"
        c.to = "blah@exmaple.com"
      }

      RackExceptionHandler::Plugins::Slack.configure { |c|
        c.web_hook = "https://hooks.slack.com/service/sekrets"
        c.http_client = Plugins::Slack::NoOpClient
      }
    end

    context "when there are no errors" do
      let(:app) do
        proc{ [ 200, {} , [ "Hello World!" ] ] }
      end
      let(:stack) { described_class.new(app) }
      let(:request) { Rack::MockRequest.new(stack) }
      subject { request.get("/").body }
      it { is_expected.to eq "Hello World!" }
    end

    context "When a post request is made but params are NOT present" do
      let(:app) do
        proc{ [ 200, {} , [ 'no-errors' ] ] }
      end
      let(:stack) { described_class.new(app) }
      let(:request) { Rack::MockRequest.new(stack) }
      subject { request.post("/", {"rack.session" => {"rack_exception": true}}).body }
      it { is_expected.to eq("no-errors") }
    end

    context "When an error is thrown in the host app" do
      let(:app) do
        proc{ [ 200, {} , [ nil.blah ] ] }
      end
      let(:stack) { described_class.new(app) }
      let(:request) { Rack::MockRequest.new(stack) }
      subject { request.get("/").body }
      it {
        is_expected.to have_tag('form', :with => { :method => 'post' }) do
          with_tag "h1", :text => 'Uh oh! Sorry, but something has gone wrong.'
          with_tag "textarea", :class => 'hidden', name: 'message'
          with_tag "textarea", :class => 'textarea', name: 'exception'
          with_tag "input", type: 'button'
        end
      }
    end

    context "after shown the error page and the user fills out the form" do

      let(:app) do
        proc{ [ 200, {} , [ "ok" ] ] }
      end
      let(:stack) { described_class.new(app) }
      let(:request) { Rack::MockRequest.new(stack) }

      context "When sending the form" do
        subject(:response) do
          session =  {"rack_exception" => true}
          params = {exception: "{\"message\":\"undefined method `blah' for nil:NilClass\",\"backtrace\":[\"/Users/tatum/Code/awesome_app/app/controllers/comments_controller.rb:8:in `index'\",\"/Users/tatum/.rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_controller/metal/implicit_render.rb:4:in `send_action'\"]}", message: "blah blah blah"}
          request.post("/", {"rack.session" => session, params: params})
        end
        it { expect(response.body).to have_tag("h1", :text => "Thank You") }

        it do
          expect(Mail).to receive(:new)
          session =  {"rack_exception" => true}
          params = {exception: "{\"message\":\"undefined method `blah' for nil:NilClass\",\"backtrace\":[\"/Users/tatum/Code/awesome_app/app/controllers/comments_controller.rb:8:in `index'\",\"/Users/tatum/.rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_controller/metal/implicit_render.rb:4:in `send_action'\"]}", message: "blah blah blah"}
          request.post("/", {"rack.session" => session, params: params})
        end
      end

    end

  end
end
