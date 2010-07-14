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

    should "load balance messages to each of the subscribers" do
      with_em do
        stream = StubTwitterStream.new
        sink_a = DataSink.new
        sink_b = DataSink.new
        Twitter::JSONStream.stubs(:connect).returns(stream)
        broadcaster = TweetBroadcaster.new
        broadcaster.subscribe(sink_a)
        broadcaster.subscribe(sink_b)
        broadcaster.start
        stream.push_message "hello"
        stream.push_message "world"
        assert_equal ["hello", "\r"], sink_b.sent_data
        assert_equal ["world", "\r"], sink_a.sent_data
      end
    end

    should "not load balance to unsubscribed clients" do
      with_em do
        stream = StubTwitterStream.new
        sink_a = DataSink.new
        sink_b = DataSink.new
        Twitter::JSONStream.stubs(:connect).returns(stream)
        broadcaster = TweetBroadcaster.new
        broadcaster.subscribe(sink_a)
        broadcaster.subscribe(sink_b)
        broadcaster.unsubscribe(sink_b)
        broadcaster.start
        stream.push_message "hello"
        stream.push_message "world"
        assert_equal ["hello", "\r", "world", "\r"], sink_a.sent_data
      end
    end


    should "log errors"
    should "handle failing reconects, how?"
  end

  context "publish" do
    should "push tweets into the channel" do
      EM.run do
        broadcaster = TweetBroadcaster.new
        sink = DataSink.new
        broadcaster.subscribe(sink)

        broadcaster.publish "hello"
        assert_equal ["hello", "\r"], sink.sent_data
        EM.stop
      end
    end
  end
end
