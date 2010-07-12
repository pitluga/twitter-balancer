class TweetBroadcaster
  extend Forwardable
  def_delegators :@channel, :unsubscribe

  def initialize
    @channel = EM::Channel.new
    @pool = []
    @pool_index = 0
  end

  def subscribe(client)
    @pool << client.signature
    @channel.subscribe do |tweet|
      if client.signature == @pool[@pool_index]
        client.send_data tweet
        client.send_data "\r"
      end
    end
  end

  def publish(tweet)
    @pool_index = (@pool_index + 1) % @pool.size if @pool.any?
    @channel.push tweet
  end

  def start
    stream = Twitter::JSONStream.connect(
      :path    => '/1/statuses/filter.json?track=football',
      :auth    => 'haikufirehose:erifukiah'
    )

    stream.each_item { |item| publish item }
    stream.on_error { |message| puts message }
    stream.on_max_reconnects do |timeout, retries|
      raise "Failed reconnecting with #{timeout} after #{retries}"
    end
  end
end
