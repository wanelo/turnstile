require 'spec_helper'
require 'timecop'

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

  describe "general tests" do
    let(:expected_stats) do
      {
          'total' => 3,
          'platforms' => {
            'ios' => 2,
            'unknown' => 1
          }
      }
    end

    it "tracks concurrent users online in different time windows" do
      Timecop.freeze Time.at(previous_window) do
        tracker.track(uid_1, platform)
        tracker.track(uid_2, platform)
        tracker.track(uid_3)
      end
      Timecop.freeze Time.at(window) do
        tracker.track(uid_4, platform)
        tracker.track(uid_5)
        expect(observer.stats).to eql expected_stats
      end
    end
  end
end
