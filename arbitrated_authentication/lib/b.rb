require 'node'
module NetSec
  class B < Node
    def initialize(id, keygen_id, channel)
      super(id, channel)
      @keygen = keygen_id
    end

    def step_4
      @t2 = msg.delete :t2
      @msg_from_a = msg
      transmit(msg, @keygen)
    end

    def step_5
      u1 = private_decrypt(msg)
      @key = u1[:k]
    end

    def step_6
      t2_hat = signature_tag_for(@msg_from_a, @key)

      raise SecurityError, "Invalid message signature" unless @t2 == t2_hat
    end

    def key!
      @key.unpack("H*")
    end
  end
end
