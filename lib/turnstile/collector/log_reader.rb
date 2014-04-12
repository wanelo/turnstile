require 'file-tail'

module Turnstile
  module Collector
    class LogReader

      def self.wanelo_ruby(file, queue)
        new(file, queue, %r{x-rqst}, ->(line){line.split(' ')[8]})
      end

      attr_accessor :file, :queue, :must_match, :extractor

      def initialize file, queue, must_match, extractor
        @file = Turnstile::Collector::File.new(file)
        @file.interval = 1
        @file.backward(0)
        @must_match = must_match
        @queue = queue
        @extractor = extractor
      end

      def run
        Thread.new do
          Thread.current[:name] = "log-reader"
          Turnstile::Logger.log "starting to tail file #{file.path}...."
          process!
        end
      end


      def process!
        self.read do |line|
          queue << line if line
        end
      end

      def read &block
        file.tail do |line|
          if must_match.nil? || must_match.match(line)
            block.call(extract(line))
          end
        end
      end

      def close
        (file.close if file) rescue nil
      end

      private

      def extract line
        case extractor
          when Regexp
            matches = line.match(extractor)
            matches.first unless matches.nil?
          when Proc
            extractor.call(line)
        end
      end
    end

    class File < ::File
      include ::File::Tail
    end
  end
end
