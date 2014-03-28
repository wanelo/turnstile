require 'spec_helper'

describe Turnstile::Adapter do

  subject { Turnstile::Adapter.new }

  let(:redis) { subject.send(:redis) }

  let(:uid) { 1238438 }
  let(:other_uid) { 1238439 }
  let(:another_uid) { 1238440 }

  let(:ip) { '1.2.3.4' }
  let(:another_ip) { '4.3.2.1' }

  let(:platform) { :ios }
  let(:another_platform) { :android }

  describe "#add" do
    it "calls redis with the correct params" do
      key = "t:#{uid}:#{platform}:#{ip}"
      expect(redis).to receive(:setex).once.with(key, Turnstile.config.activity_interval, 1)
      subject.add(uid, platform, ip)
    end
  end

  describe "#fetch" do
    let(:expected_hash) do
      [
        { uid: uid.to_s, platform: platform.to_s, ip: ip },
        { uid: other_uid.to_s, platform: platform.to_s, ip: ip},
        { uid: another_uid.to_s, platform: another_platform.to_s, ip: another_ip},
      ]
    end

    before do
      subject.add(uid, platform, ip)
      subject.add(other_uid, platform, ip)
      subject.add(another_uid, another_platform, another_ip)
    end

    it "pulls the platform specific stats from redis" do
      expect(subject.fetch).to eql expected_hash
    end
  end

end
