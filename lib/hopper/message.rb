require 'msgpack'

require 'hopper'

module Hopper
  class Message
    def initialize(payload)
      @payload = payload
    end

    attr_reader :payload
  end
end
