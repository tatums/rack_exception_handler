require 'spec_helper'

describe RackExceptionHandler do
  it 'has a version number' do
    expect(RackExceptionHandler::VERSION).not_to be nil
  end

  describe ".plugins" do
    context "when NO plugins configured" do
      subject { RackExceptionHandler.plugins  }
      it { is_expected.to eq [] }
    end
  end
end
