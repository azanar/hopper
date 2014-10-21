require File.expand_path('../../test_helper', __FILE__)

require 'hopper/channel'

class Hopper::ChannelTest < Test::Unit::TestCase 
  setup do
    @mock_bunny = mock
    Bunny.expects(:new).returns(@mock_bunny)
    @mock_bunny.expects(:start)

    @mock_channel = mock
    @mock_bunny.expects(:create_channel).returns(@mock_channel)

    @mock_channel.expects(:prefetch).with(1)

    @channel = Hopper::Channel.new
  end

  test '#queue' do
    mock_queue_name = "foo"

    mock_queue = mock
    Hopper::Queue.expects(:new).with(mock_queue_name).returns(mock_queue)

    mock_proxy = mock
    Hopper::Channel::Proxy.expects(:new).with(@channel, @mock_channel).returns(mock_proxy)

    mock_channel_queue = mock
    Hopper::Channel::Queue.expects(:new).with(mock_proxy, mock_queue).returns(mock_channel_queue)

    result = @channel.queue("foo")

    assert_equal result, mock_channel_queue
  end
end
