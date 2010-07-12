module Twitter
  module Balancer
    class Server
      def self.start(port)
        EM.epoll
        EM.run do
          trap("TERM") { stop }
          trap("INT")  { stop }
          broadcaster = TweetBroadcaster.new
          broadcaster.start
          EventMachine::start_server('0.0.0.0', port, RequestHandler, {:tweet_broadcaster => broadcaster})
        end
      end

      def self.stop
        EventMachine.stop
      end
    end
  end
end
