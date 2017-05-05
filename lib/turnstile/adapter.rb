require 'redis'
require 'timeout'

module Turnstile
  class Adapter
    attr_accessor :redis
    include Timeout

    def initialize
      self.redis = ::Redis.new(host: config.redis.host,
                               port: config.redis.port,
                               db:   config.redis.db)
    end

    def add(uid, platform, ip)
      key = compose_key(uid, platform, ip)
      timeout(config.redis.timeout) do
        redis.setex(key, config.activity_interval, 1)
      end
    rescue StandardError => e
      Turnstile::Logger.log "exception while writing to redis: #{e.inspect}"
    end

    def fetch
      redis.keys('t:*').map do |key|
        fields = key.split(':')
        {
          uid:      fields[1],
          platform: fields[2],
          ip:       fields[3],
        }
      end
    end

    def aggregate
      redis.keys('t:*').inject({}) { |hash, key| increment_platform(hash, key) }.tap do |h|
        h['total'] = h.values.inject(&:+) || 0
      end
    end

    private

    def increment_platform(hash, key)
      platform       = key.split(':')[2]
      hash[platform] ||= 0
      hash[platform] += 1
      hash
    end

    def config
      Turnstile.config
    end


    def compose_key(uid, platform = nil, ip = nil)
      "t:#{uid}:#{platform}:#{ip}"
    end

  end
end
