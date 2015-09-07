require 'spec_helper'

module RackExceptionHandler
  describe Middleware do

    let(:app) do
      proc{ [ 200, {} , [ "Hello World!" ] ] }
    end
    let(:stack) { described_class.new(app) }
    let(:request) { Rack::MockRequest.new(stack) }

    subject { request.get("/").body }
    context "when there are no errors" do
      it { is_expected.to eq "Hello World!" }
    end

    context "When an error is thrown in the host app" do
      let(:app) do
        proc{ [ 200, {} , [ nil.blah ] ] }
      end
      it {
        is_expected.to have_tag("h1") { with_text "ERROR: undefined method `blah' for nil:NilClass" }
      }
    end

  end
end
