require 'socket'

module FeedlyBot
  class Environment
    def self.hostname
      return Socket.gethostname
    end

    def self.ip_address
      udp = UDPSocket.new
      udp.connect('128.0.0.0', 7)
      addr = Socket.unpack_sockaddr_in(udp.getsockname)[1]
      udp.close
      return addr
    end
  end
end
