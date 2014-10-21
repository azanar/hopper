require File.expand_path('../test_helper', __FILE__)

require 'bunny'

require 'timeout'

require 'hopper'

require 'hopper/channel'
require 'hopper/queue'

module Hopper
  class IntegrationTest < Test::Unit::TestCase
    test "explicit queue definition" do
      channel = Hopper::Channel.new

      queue = Hopper::Queue.new("hopper-stresstest")
    
      publisher = queue.publisher(channel)
      listener = queue.listener(channel)

      run_queue(publisher, listener)
    end

    test "implicit queue definition" do
      channel = Hopper::Channel.new

      queue = channel.queue("hopper-stresstest")
    
      publisher = queue.publisher
      listener = queue.listener
      
      run_queue(publisher, listener)

    end

    def run_queue(publisher, listener)
      messages = 10.times.map do |x|
        Message.new("message#{x}")
      end
      
      messages.each do |m|
        publisher.publish(m)
      end

      received = []

      Timeout::timeout(1) do
        listener.listen do |m|
          received << m
          m.acknowledge
          if received.length == 10
            m.terminate
          end
        end
      end

      assert_equal 10, received.length
    end
  end
end
