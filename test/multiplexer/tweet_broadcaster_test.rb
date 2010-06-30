require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class TweetBroadcasterTest < Test::Unit::TestCase

  context "delegation to channel" do
    should "allow a socket to subscribe" do
      assert TweetBroadcaster.new.respond_to?(:subscribe)
    end

    should "allow a socket to unsubscribe" do
      assert TweetBroadcaster.new.respond_to?(:unsubscribe)
    end
  end

  context "reading twitter stream" do

    should "read from twitter" do
      Twitter::JSONStream.expects(:connect).returns(stub_everything)
      TweetBroadcaster.new.start
    end

    should "push messages recieved to the subscribers with carriage return" do
      EM.run do
        stream = StubTwitterStream.new
        sink = DataSink.new
        Twitter::JSONStream.stubs(:connect).returns(stream)
        broadcaster = TweetBroadcaster.new
        broadcaster.subscribe(sink)
        broadcaster.start
        stream.push_message "hello"
        assert_equal ["hello", "\r"], sink.sent_data
        EM.stop
      end
    end

    should "log errors"
    should "handle failing reconects, how?"
  end
end
