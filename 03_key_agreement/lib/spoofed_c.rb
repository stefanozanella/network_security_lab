require 'c'

module NetSec
  class SpoofedC < C
    alias :original_step_2 :step_2

    def initialize(id, channel)
      super(id, channel)

      channel.eavesdrop(self)
    end

    def step_2
      original_step_2

      # Now we maliciously save the shared key for future use
      self.shared_key = @u1[:k]
    end
  end
end
