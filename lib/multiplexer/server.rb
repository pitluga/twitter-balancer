class Server
  def self.start(port)
    EM.epoll
    EM.run do
      trap("TERM") { stop }
      trap("INT")  { stop }
      EventMachine::start_server('0.0.0.0', port, RequestHandler, {:channel => channel})
    end
  end

  def self.stop
    EventMachine.stop
  end

end
