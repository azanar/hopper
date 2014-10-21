module Hopper
  class Channel
    class Queue
      class Publisher
        def initialize(proxy, opts = {})
          @proxy = proxy
        end

        def publish(message, opts = {})
          @proxy.publish(message.payload, opts)
        end
      end
    end
  end
end
