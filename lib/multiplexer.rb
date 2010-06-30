require 'rubygems'
require 'eventmachine'
require 'twitter/json_stream'
require 'forwardable'

require File.expand_path(File.dirname(__FILE__) + '/multiplexer/tweet_broadcaster')
require File.expand_path(File.dirname(__FILE__) + '/multiplexer/request_handler')
