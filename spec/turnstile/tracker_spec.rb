require 'spec_helper'

describe Turnstile::Tracker do

  subject { Turnstile::Tracker.new }

  let(:adapter) { subject.send(:adapter) }

  let(:uid) { 1238438 }
  let(:platform) { :ios }
  let(:ip) { '1.2.3.4' }

  describe "#track" do
    it "calls adapter with correct parameters" do
      expect(adapter).to receive(:add).once.with(uid, platform, ip)
      subject.track(uid, platform, ip)
    end

    it "does not track if sampler returns no" do
      allow_any_instance_of(Turnstile::Sampler).to receive(:sample).and_return false
      expect(adapter).to receive(:add).never
      subject.track(uid)
    end
  end
end
