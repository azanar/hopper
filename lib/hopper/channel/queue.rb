module Hopper
  class Channel
    class Queue
      class Proxy
        def initialize(bunny)
          @bunny = bunny
        end
        
        def channel
          @bunny.channel
        end

        def publish(message, opts = {})
          @bunny.publish(message, opts)
        end

        def subscribe(*args)
          @bunny.subscribe(*args) do |*a|
            yield a
          end
        end
      end

      def initialize(channel,queue)
        @channel = channel
        @queue = queue

      end

      attr_reader :queue

      def listener(opts = {})
        Hopper::Channel::Queue::Listener.new(proxy, opts)
      end

      def publisher(opts = {})
        Hopper::Channel::Queue::Publisher.new(proxy, opts)
      end

      private

      def proxy
        Hopper::Channel::Queue::Proxy.new(bunny)
      end

      def bunny
        @bunny ||= @queue.for_channel(@channel)
      end
    end
  end
end
