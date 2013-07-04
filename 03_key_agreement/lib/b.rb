require 'node'
module NetSec
  class B < Node
    def initialize(id, keygen_id, keygen_pubkey, channel)
      super(id, channel)
      @keygen = keygen_id
      @keygen_pubkey = keygen_pubkey
    end

    def step_4
      @t2 = msg.delete :t2
      @msg_from_a = msg
      transmit(msg, @keygen)
    end

    def step_5
      u1 = private_decrypt(msg)
      self.shared_key = u1[:k]
    end

    def step_6
      t2_hat = signature_tag_for(@msg_from_a, shared_key)

      raise SecurityError, "Invalid message signature" unless @t2 == t2_hat
    end
  end
end
