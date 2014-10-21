require File.expand_path('../../../../test_helper', __FILE__)

require 'hopper/channel/queue/publisher'

class Hopper::Channel::Queue::PublisherTest < Test::Unit::TestCase 
  setup do
    @mock_queue_proxy = mock

    @publisher = Hopper::Channel::Queue::Publisher.new(@mock_queue_proxy, {:encoder => @mock_encoder})
  end

  test "#publish" do
    mock_message = mock

    mock_payload = mock
    mock_message.expects(:payload).returns(mock_payload)

    @mock_queue_proxy.expects(:publish).with(mock_payload, {})

    @publisher.publish(mock_message)
  end
end
