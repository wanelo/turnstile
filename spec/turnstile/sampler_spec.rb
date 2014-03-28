require 'spec_helper'

describe Turnstile::Sampler do

  subject { Turnstile::Sampler.new }

  let(:uid) { '1238438' }
  let(:other_uid) { 'some_id' }

  before do
    allow(Turnstile.config).to receive(:sampling_rate).and_return(8)
    allow(uid).to receive(:hash).and_return(231400080)
    allow(other_uid).to receive(:hash).and_return(231400090)
  end

  describe "#sample" do
    it "samples correctly" do
      allow_any_instance_of(Time).to receive(:day).and_return(15)
      expect(subject.sample(uid)).to be false
      expect(subject.sample(other_uid)).to be true
    end

    it "samples depending on the day of the month" do
      allow_any_instance_of(Time).to receive(:day).and_return(25)
      expect(subject.sample(uid)).to be true
      expect(subject.sample(other_uid)).to be false
    end
  end

  describe "#extrapolate" do
    it "extrapolates the given stat" do
      expect(subject.extrapolate(2)).to eql((2 * 12.5).to_i)
    end
  end
end
