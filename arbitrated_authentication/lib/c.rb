require 'node'

module NetSec
  class C < Node
    KEY_SIZE = 32 # For AES-256

    def initialize(id, channel)
      super(id, channel)
      @pub_keys = {}
    end

    def register_node(id, pub_key)
      @pub_keys[id] = pub_key
    end

    def step_2
      r_a = msg[:r_a]
      id_a = msg[:id_a]
      k = Random.new.bytes(KEY_SIZE)
      @u1 = { k: k, r_a: r_a }
      x1 = public_encrypt(@pub_keys[id_a], @u1)

      transmit(x1, id_a)
    end

    def step_5
      id_b = msg[:id_b]
      x3 = public_encrypt(@pub_keys[id_b], @u1)

      transmit(x3, id_b)
    end
  end
end
