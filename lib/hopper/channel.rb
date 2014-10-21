require 'bunny'

require 'hopper/queue'
require 'hopper/channel/queue'

module Hopper
  class Channel
    class Proxy
      def initialize(hopper, bunny)
        @hopper = hopper
        @bunny = bunny
      end

      def queue(name)
        @bunny.queue(name)
      end
    end

    def initialize
      conn = Bunny.new
      conn.start

      @bunny = conn.create_channel
      @bunny.prefetch(1)

      @queues = {}
    end

    def queue(name)
      if @queues.has_key?(name)
        @queues[name] 
      else
        #TODO: This violates SRP. We both manage caching the queues and
        #constructing a bunch of intermediate objects. I'm wondering if this
        #belongs more in a factory somewhere else.
        queue = Hopper::Queue.new(name)
        proxy = Hopper::Channel::Proxy.new(self, @bunny)
        @queues[name] = Hopper::Channel::Queue.new(proxy, queue)
      end
    end
  end
end
