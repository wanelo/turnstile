require 'spec_helper'
require 'timecop'

describe Turnstile::Tracker do

  subject { Turnstile::Tracker.new }

  let(:adapter) { subject.send(:adapter) }

  let(:uid) { 1238438 }

  let(:timestamp) { 1394508408 }
  let(:window_timestamp) { 1394508360 }

  let(:platform) { :ios }

  describe "#track" do
    it "calls adapter with the correct window" do
      Timecop.freeze Time.at(timestamp) do
        expect(adapter).to receive(:add).once.with(window_timestamp, uid, platform)
        subject.track(uid, platform)
      end
    end
  end
end
