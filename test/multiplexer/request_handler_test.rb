require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class RequestHandlerTest < Test::Unit::TestCase

  context "request_recieved" do
    should "respond with the standard http response code" do
      handler = RequestHandler.new :sig, :tweet_broadcaster => TweetBroadcaster.new
      handler.expects(:send_data).with(regexp_matches(%r[HTTP/1.1 200 OK]))
      handler.receive_request({}, "")
    end

    should "respond with a content-type header" do
      handler = RequestHandler.new :sig, :tweet_broadcaster => TweetBroadcaster.new
      handler.expects(:send_data).with(regexp_matches(%r[Content-Type: application/json]))
      handler.receive_request({}, "")
    end

    should "contain a new line-carriage return in the response" do
      handler = RequestHandler.new :sig, :tweet_broadcaster => TweetBroadcaster.new
      handler.expects(:send_data).with(regexp_matches(%r[^\r$]))
      handler.receive_request({}, "")
    end

    should_eventually "subscribe to the tweet broadcaster when the request is recieved" do
      broadcaster = TweetBroadcaster.new
      handler = RequestHandler.new(:sig, :tweet_broadcaster => broadcaster)
      handler.stubs(:send_data)
      handler.receive_request({}, "")

      with_em do
        handler.expects(:send_data).with("tweet")
        handler.expects(:send_data).with("\r")
        broadcaster.publish "tweet"
      end
    end
  end

end
