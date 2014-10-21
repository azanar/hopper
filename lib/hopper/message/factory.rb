class Hopper
  class Message
    class Factory
      def initialize(encoder)
        @decoder_klass = encoder_klass
      end

      def build(payload)
        message = Hopper::Message.new(payload, encoder)
        @decoder_klass.new(message)
      end
    end
  end
end
