require 'spec_helper'

describe Turnstile::Configuration do

  subject(:config) { Turnstile::Configuration.new }

  let(:spec_ip) { '128.23.12.8' }
  let(:spec_port) { '2134' }
  let(:spec_db) { '13' }
  let(:spec_timeout) { 0.087 }
  let(:spec_activity_interval) { 30 }
  let(:spec_sampling_rate) { 10 }

  context 'using redis sub-config method missing' do
    before do
      config.configure do |c|
        c.redis.configure do |r|
          r.host = spec_ip
          r.port = spec_port
          r.db = spec_db
          r.timeout = spec_timeout
        end
        c.activity_interval = spec_activity_interval
        c.sampling_rate     = spec_sampling_rate
      end
    end

    context 'main config' do
      its(:activity_interval) { should eq spec_activity_interval }
      its(:sampling_rate) { should eq spec_sampling_rate }
    end

    context 'redis sub-config' do
      subject(:redis_config) { config.redis }
      its(:host) { should eq spec_ip }
      its(:port) { should eq spec_port.to_i }
      its(:db) { should eq spec_db.to_i }
      its(:timeout) { should eq spec_timeout.to_f }
    end
  end

  context 'using redis_<property> method missing' do
    before do
      config.configure do |c|
        c.redis_host        = spec_ip
        c.redis_port        = spec_port
        c.redis_db          = spec_db
        c.redis_timeout     = spec_timeout
        c.activity_interval = spec_activity_interval
        c.sampling_rate     = spec_sampling_rate
      end
    end

    its(:redis_host) { should eq spec_ip }
    its(:redis_port) { should eq spec_port.to_i }
    its(:redis_db) { should eq spec_db.to_i }
    its(:redis_timeout) { should eq spec_timeout.to_f }
    its(:activity_interval) { should eq spec_activity_interval }
    its(:sampling_rate) { should eq spec_sampling_rate }
  end

  context 'without explicit assignment' do
    let(:spec_ip) { '127.0.0.1' }
    let(:spec_port) { 6379 }
    let(:spec_db) { 1 }
    let(:spec_timeout) { 0.05 }
    let(:spec_activity_interval) { 60 }
    let(:spec_sampling_rate) { 100 }

    its(:redis_host) { should eq spec_ip }
    its(:redis_port) { should eq spec_port }
    its(:redis_db) { should eq spec_db }
    its(:redis_timeout) { should eq spec_timeout }
    its(:activity_interval) { should eq spec_activity_interval }
    its(:sampling_rate) { should eq spec_sampling_rate }
  end

end
