require 'openssl'
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

    def receive(msg)
      @msg = YAML.load msg
    end

    def public_key
      @priv_key.public_key
    end

    def key!
      @key.unpack("H*")
    end

    def secure_transmit(data, dest)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt
      cipher.key = shared_key
      iv = cipher.random_iv
      crypted_data = cipher.update(data.to_yaml) + cipher.final

      transmit({ iv: iv, data: crypted_data }, dest, true)
    end

    def secure_receive(data)
      receive(data)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.decrypt
      cipher.key = shared_key
      cipher.iv = msg[:iv]
      decrypted_data = cipher.update(msg[:data]) + cipher.final

      receive(decrypted_data)
    end

    private

    def private_key
      @priv_key
    end

    def shared_key
      @key
    end

    def shared_key=(key)
      @key = key
    end

    def transmit(msg, dest, secure = false)
      @channel.tx(msg.to_yaml, dest, secure)
    end

    def public_encrypt(key, msg)
      key.public_encrypt(msg.to_yaml)
    end

    def private_decrypt(msg)
      YAML.load private_key.private_decrypt msg
    end

    def signature_tag_for(data, key)
      OpenSSL::HMAC.digest(OpenSSL::Digest::SHA512.new, key, data.to_yaml)
    end
  end
end
