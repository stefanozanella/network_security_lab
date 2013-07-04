require 'a'

module NetSec
  class AntispoofingA < A
    def step_1
      @r_a = Random.new.bytes(NONCE_SIZE)
      
      transmit(
        public_encrypt(
          @keygen_pubkey,
          { id_a: id, id_b: @destination, r_a: @r_a }),
        @keygen)
    end
  end
end
