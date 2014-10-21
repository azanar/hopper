require File.expand_path('../test_helper', __FILE__)

require 'hopper/channel'
require 'hopper/queue'

module Hopper
  module Test
    class MemoryTest < ::Test::Unit::TestCase

      setup do
        @channel = Hopper::Channel.new
        @queue = Hopper::Queue.new("hopper-perftest-out").publisher(@channel)
      end

      test "publish big ass messages" do

        f = File.new("test/performance/data/latin", "rb")
        arr = f.read(400).split("").permutation

        start_count = snapshot

        3000000.times do |m|
          m = arr.next.join("")
          message = OpenStruct.new
          message.payload = m

          @queue.publish(message)
        end

        end_count = snapshot
        diff_count = Hash[(start_count.keys & end_count.keys).map {|k| 
          [k, end_count[k] - start_count[k]]
        }]
        diff_arr = diff_count.select {|rec, val| 
          val > 0
        }
        puts diff_arr.inspect
        gets
        snapshot
      end

      def snapshot
        objects = Hash.new(0)
        ObjectSpace.each_object do |obj|
          objects[obj.class.name] += 1
        end
        objects
      end 

    end
  end
end
