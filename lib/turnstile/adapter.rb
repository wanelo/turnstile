require 'redis'

module Turnstile
  class Adapter

    def add(uid, platform, ip)
      key = compose_key(uid, platform, ip)
      Timeout.timeout(Turnstile.config.redis_timeout) do
        redis.setex(key, Turnstile.config.activity_interval, 1)
      end
    rescue StandardError => e
      Turnstile::Logger.log "exception while writing to redis: #{e.inspect}"
    end

    def fetch
      redis.keys("t:*").map do |key|
        fields = key.split(':')
        {
          uid: fields[1],
          platform: fields[2],
          ip: fields[3],
        }
      end
    end

    def aggregate
      h = redis.keys("t:*").inject({}) do |hash, key|
        platform = key.split(':')[2]
        hash[platform] ||= 0
        hash[platform] += 1
        hash
      end
      total = h.values.inject(&:+) || 0
      h['total'] = total
      h
    end

    private

    def compose_key(uid, platform = nil, ip = nil)
      "t:#{uid}:#{platform}:#{ip}"
    end

    def redis
      @redis_conn ||= ::Redis.new(host: Turnstile.config.redis_host,
                                  port: Turnstile.config.redis_port,
                                  db:   Turnstile.config.redis_db)
    end
  end
end
