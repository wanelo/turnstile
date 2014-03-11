require 'turnstile/version'
require 'turnstile/configuration'

module Turnstile
  def self.configure(&block)
    @configuration = Turnstile::Configuration.new.configure(&block)
  end

  def self.config
    @configuration ||= Turnstile::Configuration.new
  end
end
