require 'channel'
require 'a'
require 'b'
require 'c'

module NetSec
  class KeyExchange
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

      puts a.key!
      puts b.key!
    end
  end
end
