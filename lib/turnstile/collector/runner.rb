require 'thread'
require 'daemons/daemonize'


module Turnstile
  module Collector
    class Runner
      attr_accessor :config, :queue, :reader, :updater, :file

      def initialize(*args)
        @config = args.last.is_a?(Hash) ? args.pop : {}
        @file = config[:file]
        @queue = Queue.new

        config[:debug] ? Turnstile::Logger.enable : Turnstile::Logger.disable

        self.reader
        self.updater

        Daemonize.daemonize if config[:daemonize]
        STDOUT.sync = true if config[:debug]
      end

      def run
        threads = [reader, updater].map(&:run)
        threads.last.join
      end

      def updater
        @updater ||= Turnstile::Collector::Updater.new(queue,
                                                       config[:buffer_interval] || 5,
                                                       config[:flush_interval] || 6)
      end

      def reader
        @reader ||= Turnstile::Collector::LogReader.wanelo_ruby(file, queue)
      end
    end
  end
end
