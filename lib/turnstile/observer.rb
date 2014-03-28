module Turnstile
  class Observer
    def stats
      data = adapter.fetch
      platforms = Hash[data.group_by { |d| d[:platform] }.map { |k, v| [k, v.count] }]
      total = platforms.values.inject(:+)
      {
        stats: {
          total: total,
          platforms: platforms
        },
        users: data
      }
    end

    private

    def adapter
      @adapter ||= Adapter.new
    end
  end
end
