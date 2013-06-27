module NetSec
  class Channel
    def initialize
      @nodes = {}
      @eavesdroppers = []
    end

    def register(node)
      @nodes[node.id] = node
    end

    def eavesdrop(attacker)
      @eavesdroppers << attacker
    end

    def tx(msg, dest, secure = false)
      receive_method = secure ? :secure_receive : :receive

      @nodes[dest].send(receive_method, msg)

      @eavesdroppers.each do |eavesdropper|
        eavesdropper.send(receive_method, msg)
      end
    end
  end
end
