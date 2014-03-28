module Turnstile
  class Sampler
    def extrapolate(n)
      (n * 100.0 / sampling_rate).to_i
    end

    # this method uses a unique string to integer hashing (object->hash)
    # sampling shifts depending on the day of the month so that sampling
    # does not stick to the same people all the time
    def sample(uid)
      ((uid.hash + Time.now.day) % 100) < sampling_rate
    end

    private

    def sampling_rate
      Turnstile.config.sampling_rate
    end
  end
end
