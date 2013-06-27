require 'channel'
require 'a'
require 'b'
require 'c'
require 'spoofed_c'

module NetSec
  class KeyAgreement
    # Original protocol implementation
    def start!
      setup_nodes(A, B, C)

      key_agreement

      puts "A has key: #{@a.key!}"
      puts "B has key: #{@b.key!}"
    end

    # Simulation of spoofing C identity
    def spoofing_attack!
      setup_nodes(A, B, SpoofedC)

      key_agreement

      puts "A has key: #{@a.key!}"
      puts "B has key: #{@b.key!}"
      puts "Spoofed C has key: #{@c.key!}"

      @a.secure_send "My credit card number is 1234567890123456"
      puts "B received: #{@b.msg}"
      puts "The attacker eavesdropped: #{@c.msg}"
    end

    def setup_nodes(klass_a, klass_b, klass_c)
      @channel = Channel.new
      @c = klass_c.new("exchanger.example.com", @channel)
      @a = klass_a.new("alice.example.com", "bob.example.com", @c.id, @channel)
      @b = klass_b.new("bob.example.com", @c.id, @channel)

      @channel.register @a
      @channel.register @b
      @channel.register @c

      @c.register_node(@a.id, @a.public_key)
      @c.register_node(@b.id, @b.public_key)
    end

    def key_agreement
      @a.step_1

      @c.step_2
      @a.step_2

      @a.step_3

      @b.step_4

      @c.step_5
      @b.step_5

      @b.step_6
    end
  end
end
