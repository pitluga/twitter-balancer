require File.expand_path(File.dirname(__FILE__) + '/../../lib/twitter/balancer')
require File.expand_path(File.dirname(__FILE__) + '/../infrastructure/data_sink')
require File.expand_path(File.dirname(__FILE__) + '/../infrastructure/stub_twitter_stream')
require 'shoulda'
require 'mocha'

def with_em
  EM.run do
    yield
    EM.stop
  end
end
