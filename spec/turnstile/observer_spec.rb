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

  let(:extrapolated_stats) do
    {
      stats: {
        total: 20,
        platforms: {
          ios: 20
        }
      },
      users: sample_data
    }
  end

  describe '#stats' do
    context 'when there are users' do
      before do
        expect(adapter).to receive(:fetch).once.and_return(sample_data)
      end

      it 'fetches data from adapter and aggregates it' do
        expect(subject.stats).to eql(expected_stats)
      end

      it 'extrapolates numbers correctly' do
        allow(Turnstile.config).to receive(:sampling_rate).and_return(5)
        expect(subject.stats).to eql(extrapolated_stats)
      end
    end

    context 'when there are no users' do
      before do
        expect(adapter).to receive(:fetch).once.and_return([])
      end

      it 'returns 0 for total' do
        expect(subject.stats[:stats][:total]).to eql 0
      end
    end
  end
end
