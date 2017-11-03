require 'hashie/dash'
require 'hashie/extensions/dash/property_translation'

module Turnstile
  class RedisConfig < ::Hashie::Dash
    include Hashie::Extensions::Dash::PropertyTranslation

    property :host, default: '127.0.0.1', required: true
    property :port, default: 6379, required: true, transform_with: ->(value) { value.to_i }
    property :db, default: 1, required: true, transform_with: ->(value) { value.to_i }
    property :timeout, default: 0.05, required: true, transform_with: ->(value) { value.to_f }

    def configure
      yield self if block_given?
      self
    end
  end

  class Configuration < ::Hashie::Dash
    include Hashie::Extensions::Dash::PropertyTranslation
    property :activity_interval, default: 60, required: true, transform_with: ->(value) { value.to_i }
    property :sampling_rate, default: 100, required: true, transform_with: ->(value) { value.to_i }
    property :redis, default: ::Turnstile::RedisConfig.new

    def configure
      yield self if block_given?
      self
    end

    def method_missing(method, *args, &block)
      return super unless method.to_s =~ /^redis_/
      prop = method.to_s.gsub(/^redis_/, '').to_sym
      if self.redis.respond_to?(prop)
        prop.to_s.end_with?('=') ? self.redis.send(prop, *args, &block) : self.redis.send(prop)
      end
    end
  end
end
