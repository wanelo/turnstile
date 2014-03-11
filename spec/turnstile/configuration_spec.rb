require 'spec_helper'

describe Turnstile::Configuration do

  subject { Turnstile::Configuration.new }

  it "allows configuration via block" do
    subject.configure do |c|
      c.redis_host = "128.23.12.8"
      c.redis_port = "2134"
      c.redis_db = "13"

      c.activity_interval = 30
    end

    expect(subject.redis_host).to eql "128.23.12.8"
    expect(subject.redis_port).to eql 2134
    expect(subject.redis_db).to eql "13"

    expect(subject.activity_interval).to eql 30
  end

  it "provides redis defaults" do
    subject.configure do |config|
      # do nothing
    end

    expect(subject.redis_host).to eql "127.0.0.1"
    expect(subject.redis_port).to eql 6379
    expect(subject.redis_db).to eql "1"
    expect(subject.activity_interval).to eql 60
  end
end
