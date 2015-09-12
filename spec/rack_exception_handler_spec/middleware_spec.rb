require 'spec_helper'

module RackExceptionHandler
  describe Middleware do


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

  end
end
