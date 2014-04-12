require 'spec_helper'
require 'file/tail'
require 'timeout'
require 'thread'
require 'tempfile'

describe 'Turnstile::Collector::LogReader' do

  let(:queue) { Queue.new }
  let(:file) { "spec/fixtures/sample-production.log" }

  let(:reader) { Turnstile::Collector::LogReader.wanelo_ruby(file, queue) }
  let(:read_timeout) { 0.02 }

  before do
    reader.file.backward(1000)
  end

  def run_reader &block
    t_reader = Thread.new do
      begin
        timeout(read_timeout) do
          block.call
        end
      rescue TimeoutError
      end
    end
    t_reader.join
  end

  context "#read" do
    it "should be able to read and parse IPs from a static file" do
      hash = {}
      counter = 0

      run_reader do
        reader.read do |token|
          counter += 1
          hash[token] = 1
        end
      end

      expect(counter).to eql(746)
      expect(hash.keys.size).to eql(602)
    end
  end

  context "#process!" do
    it "should read values into the queue" do
      run_reader do
        reader.process!
      end
      expect(queue.size).to eql(746)
    end
  end
end
