require 'spec_helper'

describe Turnstile::Observer do

  subject { Turnstile::Observer.new }

  let(:adapter) { subject.send(:adapter) }

  let(:uid) { 1238438 }
  let(:platform) { :ios }
  let(:ip) { '1.2.3.4' }

  let(:sample_data) { [{uid: uid, platform: platform, ip: ip}] }

  let(:expected_stats) do
    {
      stats: {
        total: 1,
        platforms: {
          ios: 1
        }
      },
      users: sample_data
    }
  end

  describe "#stats" do
    it "fetches data from adapter and aggregates it" do
      expect(adapter).to receive(:fetch).once.and_return(sample_data)
      expect(subject.stats).to eql(expected_stats)
    end
  end
end
