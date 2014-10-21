require File.expand_path('../test_helper', __FILE__)

require 'bunny'

require 'thread'

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

    QUEUE_LENGTH = 100

    def run_queue(publisher, listener)
      message_strings = QUEUE_LENGTH.times.map do |x|
        "message#{x}"
      end

      messages = message_strings.map do |s|
        Message.new(s)
      end

      messages.each do |m|
        publisher.publish(m)
      end

      received = []

      validate_mutex = Mutex.new
      validate_latch = ConditionVariable.new

      Thread.new do
        listener.listen do |m|
          received << m
          m.acknowledge
          if received.length == QUEUE_LENGTH
            validate_latch.signal
            m.terminate
          end
        end
      end

      validate_mutex.synchronize {
        validate_latch.wait(validate_mutex)
      }

      assert_equal QUEUE_LENGTH, received.length
      received_strings = received.map {|r|
        r.message.payload
      }
      assert_equal Set.new(message_strings), Set.new(received_strings)
    end

  end
end
