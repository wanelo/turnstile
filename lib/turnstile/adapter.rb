require 'redis'

module Turnstile
  class Adapter

    def add(timestamp, uid, platform = nil)
      key = compose_key(timestamp, platform)
      redis.sadd(key, uid)
      redis.expire(key, Turnstile.config.activity_interval * 10)
    end

    def fetch(timestamp)
      platform_keys(timestamp).inject({}) do |h, key|
        platform = key.split(':')[2]
        h[(platform ? platform : 'unknown')] = redis.scard(key)
        h
      end
    end

    private

    def platform_keys(timestamp)
      redis.keys(compose_key(timestamp, '*'))
    end

    def compose_key(timestamp, platform = nil)
      "turnstile:#{timestamp}:#{platform}"
    end

    def redis
      @redis_conn ||= ::Redis.new(host: Turnstile.config.redis_host,
                                  port: Turnstile.config.redis_port,
                                  db:   Turnstile.config.redis_db)
    end
  end
end
