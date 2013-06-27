require 'openssl'
require 'node'

module NetSec
  class A < Node
    # TODO Why 8 bytes???
    NONCE_SIZE = 8.freeze
    
    def initialize(id, dest_id, keygen_id, channel)
      super(id, channel)

      @destination = dest_id
      @keygen = keygen_id
    end

    def step_1
      @r_a = Random.new.bytes(NONCE_SIZE)
      
      transmit({ id_a: id, id_b: @destination, r_a: @r_a }, @keygen)
    end

    def step_2
      u1 = private_decrypt(msg)
      self.shared_key = u1[:k]
    end

    def step_3
      x2 = { id_a: id, id_b: @destination, r_a: @r_a}
      t2 = signature_tag_for(x2, shared_key)
      x2[:t2] = t2

      transmit(x2, @destination)
    end

    def secure_send(msg)
      secure_transmit(msg, @destination)
    end
  end
end
