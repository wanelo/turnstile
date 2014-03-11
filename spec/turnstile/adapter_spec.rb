require 'spec_helper'

describe Turnstile::Adapter do

  subject { Turnstile::Adapter.new }

  let(:redis) { subject.send(:redis) }

  let(:uid) { 1238438 }
  let(:other_uid) { 1238439 }
  let(:another_uid) { 1238440 }

  let(:timestamp) { 1394508400 }

  let(:platform) { :ios }
  let(:another_platform) { :android }

  describe "#add" do
    it "calls redis with the correct params" do
      key = "turnstile:#{timestamp}:#{platform}"
      expect(redis).to receive(:sadd).once.with(key, uid)
      expect(redis).to receive(:expire).once.with(key, Turnstile.config.activity_interval * 10)
      subject.add(timestamp, uid, platform)
    end
  end

  describe "#fetch" do
    let(:expected_hash) do
      {
          'ios' => 2,
          'android' => 1
      }
    end

    before do
      subject.add(timestamp, uid, platform)
      subject.add(timestamp, other_uid, platform)
      subject.add(timestamp, another_uid, another_platform)
    end

    it "pulls the platform specific stats from redis" do
      expect(subject.fetch(timestamp)).to eql expected_hash
    end
  end

end
