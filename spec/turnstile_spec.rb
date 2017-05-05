require 'spec_helper'

describe Turnstile do

  let(:tracker) { Turnstile::Tracker.new }
  let(:observer) { Turnstile::Observer.new }

  let(:uid_1) { 1238438 }
  let(:uid_2) { 1238439 }
  let(:uid_3) { 'some_id' }
  let(:uid_4) { 1238441 }
  let(:uid_5) { 1238442 }

  let(:previous_window) { 1394508408 }
  let(:window) { 1394508468 }

  let(:platform) { :ios }
  let(:other_platform) { :android }

  let(:ip) { '1.2.3.4' }
  let(:other_ip) { '4.3.2.1' }

  describe 'general tests' do
    let(:expected_stats) do
      {
        stats: {
          total: 5,
          platforms: {
            ios:     3,
            android: 1,
            unknown: 1
          }
        },
        users: [
          {uid: uid_1.to_s, platform: platform.to_s, ip: ip},
          {uid: uid_2.to_s, platform: platform.to_s, ip: other_ip},
          {uid: uid_3.to_s, platform: other_platform.to_s, ip: ip},
          {uid: uid_4.to_s, platform: platform.to_s, ip: nil},
          {uid: uid_5.to_s, platform: 'unknown', ip: nil},
        ]
      }
    end

    before do
      tracker.track(uid_1, platform, ip)
      tracker.track(uid_1, platform, ip)
      tracker.track(uid_2, platform, other_ip)
      tracker.track(uid_2, platform, other_ip)
      tracker.track(uid_3, other_platform, ip)
      tracker.track(uid_3, other_platform, ip)
      tracker.track(uid_3, other_platform, ip)
      tracker.track(uid_4, platform)
      tracker.track(uid_5)
    end

    subject(:stats) { observer.stats }

    its(:size) { should eq expected_stats.size }

    it 'tracks concurrent users online' do
      expect(observer.stats.to_hash[:users].map(&:to_s).sort).to eq(expected_stats[:users].map(&:to_s).sort)
    end

    it 'tracks stats correctly' do
      expect(observer.stats.to_hash[:stats].map(&:to_a).sort).to eq(expected_stats[:stats].map(&:to_a).sort)
    end
  end
end
