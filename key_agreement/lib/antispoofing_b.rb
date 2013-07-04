require 'b'

module NetSec
  class AntispoofingB < B
    def step_4
      @t2 = msg.delete :t2
      @msg_from_a = msg
      transmit(
        public_encrypt(
          @keygen_pubkey,
          msg),
        @keygen)
    end
  end
end
