require 'yaml'

module NetSec
  class Node
    def initialize(id, channel)
      @id = id
      @channel = channel

      @priv_key = OpenSSL::PKey::RSA.generate 2048
    end

    def id
      @id
    end

    def msg
      @msg
    end

    def public_key
      @priv_key.public_key
    end

    def receive(msg)
      @msg = YAML.load msg
    end

    def transmit(msg, dest)
      @channel.tx(msg.to_yaml, dest)
    end

    def public_encrypt(key, msg)
      key.public_encrypt(msg.to_yaml)
    end

    def private_decrypt(msg)
      YAML.load @priv_key.private_decrypt msg
    end

    def signature_tag_for(data, key)
      OpenSSL::HMAC.digest(OpenSSL::Digest::SHA512.new, key, data.to_yaml)
    end
  end
end
