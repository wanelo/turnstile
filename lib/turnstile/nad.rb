module Turnstile
  class Nad

    def data
      out = ""
      aggregate.each_pair do |key, value|
        out << %Q(turnstile:#{key}#{"\tn\t"}#{value}\n)
      end
      out
    end

    def aggregate
      Turnstile::Adapter.new.aggregate
    end
  end
end
