require File.expand_path('../test_helper', __FILE__)

require 'hopper/queue'
require 'hopper/channel'

module Hopper
  module Test
    class Listener
      @channel = Hopper::Channel.new
      @queue = Hopper::Queue.new("hopper-perftest-out").listener(@channel)

      @queue.listen do |msg|
        msg.acknowledge
      end
    end
  end
end
