require 'turnstile/version'
require 'turnstile/configuration'
require 'turnstile/adapter'
require 'turnstile/tracker'
require 'turnstile/observer'

module Turnstile
  def self.configure(&block)
    @configuration = Turnstile::Configuration.new.configure(&block)
  end

  def self.config
    @configuration ||= Turnstile::Configuration.new
  end
end
