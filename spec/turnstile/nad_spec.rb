require 'spec_helper'

describe 'Turnstile::Nad' do

  subject { Turnstile::Nad.new }

  describe '#data' do
    context 'have some data' do
      let(:aggregate) { {
            'android' => 3,
            'ios' => 2,
            'total' => 5
        }
      }

      let(:expected_string) {
          <<-EOF
turnstile.android#{"\t"}s#{"\t"}3
turnstile.ios#{"\t"}s#{"\t"}2
turnstile.total#{"\t"}s#{"\t"}5
          EOF
      }

      it "return data in NAD tab dilimited format" do
        expect(subject).to receive(:aggregate).once.and_return(aggregate)
        expect(subject.data).to eql(expected_string)
      end
    end

  end
end
