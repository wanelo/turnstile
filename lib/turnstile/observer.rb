module Turnstile
  class Observer
    def stats
      data = adapter.fetch
      platforms = Hash[data.group_by { |d| d[:platform] }.map { |k, v| [k, sampler.extrapolate(v.count)] }]
      total = platforms.values.inject(:+)
      {
        stats: {
          total: total,
          platforms: platforms
        },
        users: data
      }
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
