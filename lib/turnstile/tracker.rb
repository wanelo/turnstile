require 'turnstile/helpers/time'

module Turnstile
  class Tracker
    include Turnstile::Helpers::Time

    def track(uid, platform = nil)
      adapter.add(window_timestamp(Time.now.to_i), uid, platform)
    end

    private

    def adapter
      @adapter ||= Adapter.new
    end
  end
end
