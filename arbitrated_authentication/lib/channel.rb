module NetSec
  class Channel
    def initialize
      @nodes = {}
    end

    def register(node)
      @nodes[node.id] = node
    end

    def tx(msg, dest)
      @nodes[dest].receive(msg)
    end
  end
end
