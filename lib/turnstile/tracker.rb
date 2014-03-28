module Turnstile
  class Tracker
    def track(uid, platform = 'unknown', ip = nil)
      adapter.add(uid, platform, ip) if sampler.sample(uid)
    end

    private

    def adapter
      @adapter ||= Adapter.new
    end

    def sampler
      @sampler ||= Sampler.new
    end
  end
end
