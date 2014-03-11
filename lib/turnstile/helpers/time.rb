module Turnstile
  module Helpers
    module Time
      def window_timestamp(timestamp, previous = false)
        interval = Turnstile.config.activity_interval
        (timestamp / interval * interval) - (previous ? interval : 0)
      end
    end
  end
end
