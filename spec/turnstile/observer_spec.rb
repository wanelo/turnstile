require 'spec_helper'
require 'timecop'

describe Turnstile::Observer do

  subject { Turnstile::Observer.new }

  let(:adapter) { subject.send(:adapter) }

  let(:uid) { 1238438 }

  let(:timestamp) { 1394508408 }
  let(:previous_window_timestamp) { 1394508300 }

  let(:platform) { :ios }

  describe "#stats" do
    it "calls adapter with the correct window" do
      Timecop.freeze Time.at(timestamp) do
        expect(adapter).to receive(:fetch).once.with(previous_window_timestamp).and_return({})
        subject.stats
      end
    end
  end
end
