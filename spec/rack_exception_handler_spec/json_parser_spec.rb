require 'spec_helper'

module RackExceptionHandler
  describe JsonParser do

    describe "#to_json" do
      context "converts an excpetion to JSON" do
        let(:exception) { double(:exception,
                                 message: "undefined method `blah' for nil:NilClass",
                                 backtrace: [
                                   "/Users/tatum/Code/awesome_app/app/controllers/comments_controller.rb:8:in `index'",
                                   "/Users/tatum/.rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_controller/metal/implicit_render.rb:4:in `send_action'"
                                 ])
        }
        subject { described_class.as_json(exception) }
        it { is_expected.to eq "{\"message\":\"undefined method `blah' for nil:NilClass\",\"backtrace\":[\"/Users/tatum/Code/awesome_app/app/controllers/comments_controller.rb:8:in `index'\",\"/Users/tatum/.rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_controller/metal/implicit_render.rb:4:in `send_action'\"]}" }
      end
    end

    describe "#from_json_to_exception" do
      let(:json) {
        "{\"message\":\"undefined method `blah' for nil:NilClass\",\"backtrace\":[\"/Users/tatum/Code/awesome_app/app/controllers/comments_controller.rb:8:in `index'\",\"/Users/tatum/.rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_controller/metal/implicit_render.rb:4:in `send_action'\"]}"
      }
      subject { described_class.from_json_to_exception(json) }
      it { is_expected.to respond_to :message }
      it { is_expected.to respond_to :backtrace }
      it { expect(subject.message).to eq "undefined method `blah' for nil:NilClass"  }
      it { expect(subject.backtrace).to eq [
                                   "/Users/tatum/Code/awesome_app/app/controllers/comments_controller.rb:8:in `index'",
                                   "/Users/tatum/.rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_controller/metal/implicit_render.rb:4:in `send_action'"
                                 ]  }
    end

  end
end
