require 'msgpack'

require 'hopper'

module Hopper
  class Message
    class Delivered
      def initialize(queue, delivery_information, properties, payload)
        @queue = queue
        @delivery_information = delivery_information
        @properties = properties
        @message = Hopper::Message.new(payload)
      end

      attr_reader :message

      class RetryableError < StandardError ; end

      class FatalError < StandardError ; end

      def acknowledge
        #Hopper.logger.info "Acknowledging #{tag}"
        @queue.acknowledge(self)
      end

      def retry
        Hopper.logger.info "Re-enqueueing #{tag}"
        @queue.retry(self)
      end

      def reject(requeue = nil)
        if !requeue.nil?
          Hopper.logger.warn "Hopper::Queue::Message#reject with requeue set to 'true' is deprecated."
          if requeue
            self.retry
          else
            self.reject
          end
        else
          Hopper.logger.info "Rejecting #{tag}"
          @queue.reject(self)
        end
      end

      def terminate
        @delivery_information.consumer.cancel
      end

      def tag
        @delivery_information.delivery_tag
      end
    end
  end
end
