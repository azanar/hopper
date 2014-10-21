require 'hopper/message/delivered'
require 'hopper/message'

module Hopper
  class Channel
    class Queue
      class Listener
        def initialize(proxy, opts = {})
          @proxy = proxy
        end

        def listen
          @proxy.subscribe(:ack => true, :block => true) do |delivery_information, properties, payload|
            message = Message::Delivered.new(self, delivery_information, properties, payload)
            begin
              yield message
            rescue Exception => e
              Hopper.logger.error "Caught exception #{e} that worker should have caught. Message #{message.tag} being rejected by default.\n\n#{e.backtrace.join("\n")}"
              reject(message)
            end
          end
        end

        def acknowledge(message)
          bunny_channel.acknowledge(message.tag)
        end

        def retry(message)
          bunny_channel.reject(message.tag, true)
        end

        def reject(message)
          bunny_channel.reject(message.tag, false)
        end

        private

        def bunny_channel
          @proxy.channel
        end
      end
    end
  end
end
