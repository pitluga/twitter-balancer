class TweetBroadcaster
  extend Forwardable
  def_delegators :@channel, :unsubscribe

  def initialize
    @channel = EM::Channel.new
  end

  def subscribe(client)
    @channel.subscribe do |tweet|
      client.send_data tweet
      client.send_data "\r"
    end
  end

  def start
    stream = Twitter::JSONStream.connect(
      :path    => '/1/statuses/filter.json?track=football',
      :auth    => 'LOGIN:PASSWORD'
   )

    stream.each_item { |item| @channel.push item }
    stream.on_error { |message| puts message }
    stream.on_max_reconnects do |timeout, retries|
      raise "Failed reconnecting with #{timeout} after #{retries}"
    end
  end
end
