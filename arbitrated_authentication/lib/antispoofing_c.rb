require 'c'

module NetSec
  class AntispoofingC < C
    def step_2
      clear_msg = private_decrypt(msg)

      r_a = clear_msg[:r_a]
      id_a = clear_msg[:id_a]
      k = Random.new.bytes(KEY_SIZE)
      @u1 = { k: k, r_a: r_a }
      x1 = public_encrypt(@pub_keys[id_a], @u1)

      transmit(x1, id_a)
    end

    def step_5
      clear_msg = private_decrypt(msg)

      id_b = clear_msg[:id_b]
      x3 = public_encrypt(@pub_keys[id_b], @u1)

      transmit(x3, id_b)
    end
  end
end
