require 'turnstile/helpers/time'

module Turnstile
  class Observer
    include Turnstile::Helpers::Time

    def stats
      adapter.fetch(window_timestamp(Time.now.to_i, true))
    end

    private

    def adapter
      @adapter ||= Adapter.new
    end
  end
end
