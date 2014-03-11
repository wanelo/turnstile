require 'turnstile/helpers/time'

module Turnstile
  class Observer
    include Turnstile::Helpers::Time

    def stats
      platforms = adapter.fetch(window_timestamp(Time.now.to_i, true))
      {
          'total' => platforms.values.inject(:+).to_i,
          'platforms' => platforms
      }
    end

    private

    def adapter
      @adapter ||= Adapter.new
    end
  end
end
