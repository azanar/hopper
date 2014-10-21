require File.expand_path('../../../test_helper', __FILE__)

require 'hopper/channel/queue'

class Hopper::Channel::QueueTest < Test::Unit::TestCase 
  setup do
    @mock_channel = mock
    @mock_queue = mock

    @channel_queue = Hopper::Channel::Queue.new(@mock_channel, @mock_queue)
  end

  test "#listener" do
    mock_bunny_queue = mock
    
    mock_proxy = mock
    Hopper::Channel::Queue::Proxy.expects(:new).with(mock_bunny_queue).returns(mock_proxy)

    @mock_queue.expects(:for_channel).with(@mock_channel).returns(mock_bunny_queue)
    result = @channel_queue.listener

    assert_kind_of Hopper::Channel::Queue::Listener, result
  end

  test "#publisher" do
    mock_bunny_queue = mock

    mock_proxy = mock
    Hopper::Channel::Queue::Proxy.expects(:new).with(mock_bunny_queue).returns(mock_proxy)

    @mock_queue.expects(:for_channel).with(@mock_channel).returns(mock_bunny_queue)
    result = @channel_queue.publisher

    assert_kind_of Hopper::Channel::Queue::Publisher, result
  end
end

class Hopper::Channel::Queue::ProxyTest < Test::Unit::TestCase 
  setup do
    @mock_bunny_queue = mock

    @proxy = Hopper::Channel::Queue::Proxy.new(@mock_bunny_queue)
  end

  test "#publish" do
    mock_message = mock
    @mock_bunny_queue.expects(:publish).with(mock_message, {})

    @proxy.publish(mock_message)
  end
  
  test "#publish with opts" do
    mock_message = mock
    @mock_bunny_queue.expects(:publish).with(mock_message, {foo: :bar})

    @proxy.publish(mock_message, {foo: :bar})
  end

  test "#subscribe" do
    mock_deliverable = mock
    @mock_bunny_queue.expects(:subscribe).yields(mock_deliverable)

    @proxy.subscribe do |deliverable|
      assert_equal [mock_deliverable], deliverable
    end
  end

  test "#subscribe with args" do
    mock_deliverable = mock
    @mock_bunny_queue.expects(:subscribe).with({foo: :bar}).yields(mock_deliverable)

    @proxy.subscribe(foo: :bar) do |deliverable|
      assert_equal [mock_deliverable], deliverable
    end
  end

end
