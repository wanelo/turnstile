module Turnstile
  module Collector
    class Updater

      class Session < ::Struct.new(:uid, :platform, :ip); end

      attr_accessor :queue, :semaphore, :cache, :tracker, :buffer_interval, :flush_interval

      def initialize(queue, buffer_interval = 5, flush_interval = 6)
        @queue = queue
        @semaphore = Mutex.new
        @cache = Hash.new(0)
        @tracker = Turnstile::Tracker.new
        @buffer_interval = buffer_interval
        @buffer_interval = 6 if @buffer_interval <= 0
        @flush_interval = flush_interval
        @flush_interval = 5 if @flush_interval <= 0
      end

      def run
        run_queue_popper
        run_flusher
      end

      private

      def run_flusher
        Thread.new do
          Thread.current[:name] = "updater:flush"
          loop do
            semaphore.synchronize {
              unless cache.empty?
                Turnstile::Logger.logging "flushing cache with [#{cache.keys.size}] keys" do
                  cache.keys.each do |key|
                    session = parse(key)
                    if session.uid && !session.uid.empty?
                      tracker.track(session.uid, session.platform, session.ip)
                    end
                  end
                  reset_cache
                end
              else
                Turnstile::Logger.log "nothing to flush, sleeping #{flush_interval}s.."
              end
            }
            sleep flush_interval
          end
        end
      end

      def run_queue_popper
        Thread.new do
          Thread.current[:name] = "updater:queue"
          loop do
            unless queue.empty?
              Turnstile::Logger.logging "caching [#{queue.size}] keys locally" do
                while !queue.empty?
                  semaphore.synchronize {
                    add(queue.pop)
                  }
                end
              end
            else
              Turnstile::Logger.log "nothing in the queue, sleeping #{buffer_interval}s..."
            end
            sleep buffer_interval
          end
        end
      end

      def add(token)
        cache[token] = 1
      end

      def parse(token)
        a = token.split(':')
        Session.new(a[2], a[0], a[1])
      end

      def reset_cache
        @cache.clear
        GC.start
      end
    end
  end
end
