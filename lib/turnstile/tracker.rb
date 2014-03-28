module Turnstile
  class Tracker
    def track(uid, platform = 'unknown', ip = nil)
      adapter.add(uid, platform, ip)
    end

    private

    def adapter
      @adapter ||= Adapter.new
    end
  end
end
