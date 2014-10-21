require 'hopper/channel/queue/publisher'
require 'hopper/channel/queue/listener'

module Hopper
  class Queue

    PRELOAD_FACTOR = 3

    def initialize(queue_name, opts = {})
      @name = queue_name

      @shaper = opts[:shaper]
    end

    def for_channel(channel)
      channel.queue(@name)
    end

    def listener(channel, opts = {})
      queue = for_channel(channel)
      queue.listener
    end

    def publisher(channel, opts = {})
      queue = for_channel(channel)
      queue.publisher
    end
  end
end
