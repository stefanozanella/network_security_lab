require 'channel'
require 'a'
require 'b'
require 'c'
require 'spoofed_c'

module NetSec
  class KeyExchange
    # Original protocol implementation
    def self.start!
      # Nodes initialization
      channel = Channel.new
      c = C.new("exchanger.example.com", channel)
      a = A.new("alice.example.com", "bob.example.com", c.id, channel)
      b = B.new("bob.example.com", c.id, channel)

      channel.register a
      channel.register b
      channel.register c

      c.register_node(a.id, a.public_key)
      c.register_node(b.id, b.public_key)

      # Key exchanging
      a.step_1

      c.step_2
      a.step_2

      a.step_3

      b.step_4

      c.step_5
      b.step_5

      b.step_6

      puts "A has key: #{a.key!}"
      puts "B has key: #{b.key!}"
    end

    # Simulation of spoofing C identity
    def self.spoofing_attack!
      channel = Channel.new
      spoofed_c = SpoofedC.new("exchanger.example.com", channel)
      a = A.new("alice.example.com", "bob.example.com", spoofed_c.id, channel)
      b = B.new("bob.example.com", spoofed_c.id, channel)

      channel.register a
      channel.register b
      channel.register spoofed_c

      spoofed_c.register_node(a.id, a.public_key)
      spoofed_c.register_node(b.id, b.public_key)

      # Key exchanging
      a.step_1

      spoofed_c.step_2
      a.step_2

      a.step_3

      b.step_4

      spoofed_c.step_5
      b.step_5

      b.step_6

      puts "A has key: #{a.key!}"
      puts "B has key: #{b.key!}"
      puts "Spoofed C has key: #{spoofed_c.key!}"

      a.secure_send "My credit card number is 1234567890123456"
      puts "B received: #{b.msg}"
      puts "The attacker eavesdropped: #{spoofed_c.msg}"
    end
  end
end
