require 'hashie/mash'
require 'hashie/extensions/mash/symbolize_keys'

module Turnstile
  class Stats < ::Hashie::Mash
    include ::Hashie::Extensions::Mash::SymbolizeKeys
  end

  class Observer
    def stats
      data      = adapter.fetch
      platforms = Hash[data.group_by { |d| d[:platform] }.map { |k, v| [k, sampler.extrapolate(v.count)] }]
      total     = platforms.values.inject(:+) || 0
      Stats.new({
                  stats: {
                    total:     total,
                    platforms: platforms
                  },
                  users: data
                })
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
