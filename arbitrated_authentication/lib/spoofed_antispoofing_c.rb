require 'antispoofing_c'

module NetSec
  class SpoofedAntispoofingC < AntispoofingC
    def private_key
      # The spoofed C doesn't have original C private key, so to simulate this
      # condition we generate a new RSA key.

      OpenSSL::PKey::RSA.generate 2048
    end
  end
end
