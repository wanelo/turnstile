module Turnstile
  class Configuration
    attr_writer :redis_host, :redis_port, :redis_db, :redis_timeout, :activity_interval, :sampling_rate

    def configure
      yield self
      self
    end

    def redis_host
      @redis_host || '127.0.0.1'
    end

    def redis_port
      (@redis_port || 6379).to_i
    end

    def redis_db
      @redis_db || '1'
    end

    def redis_timeout
      (@redis_timeout || 0.05).to_f
    end

    def activity_interval
      (@activity_interval || 60).to_i
    end

    def sampling_rate
      (@sampling_rate || 100).to_i
    end
  end
end
