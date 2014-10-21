require File.expand_path('../../test_helper', __FILE__)

require 'hopper/queue'

class Hopper::QueueTest < Test::Unit::TestCase 
  setup do
    @queue_name = "queue-test-queue"

    @queue = Hopper::Queue.new(@queue_name)
  end

  test '#listener' do
    mock_channel = mock

    mock_channel_queue = mock
    mock_channel.expects(:queue).with(@queue_name).returns(mock_channel_queue)

    mock_listener = mock
    mock_channel_queue.expects(:listener).returns(mock_listener)

    result = @queue.listener(mock_channel)

    assert_equal result, mock_listener
  end

  test '#publisher' do
    mock_channel = mock

    mock_channel_queue = mock
    mock_channel.expects(:queue).with(@queue_name).returns(mock_channel_queue)

    mock_publisher = mock
    mock_channel_queue.expects(:publisher).returns(mock_publisher)

    result = @queue.publisher(mock_channel)

    assert_equal result, mock_publisher

  end

end
