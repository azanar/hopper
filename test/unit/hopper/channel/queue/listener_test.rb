require File.expand_path('../../../../test_helper', __FILE__)

require 'hopper/channel/queue/listener'

class Hopper::Channel::Queue::ListenerTest < Test::Unit::TestCase 
  setup do
    @mock_queue_proxy = mock

    @mock_channel = mock

    @listener = Hopper::Channel::Queue::Listener.new(@mock_queue_proxy)
  end

  test '#listen' do
    mock_delivery_information = mock
    mock_properties = mock
    mock_payload = mock
    
    @mock_queue_proxy.expects(:subscribe).yields(mock_delivery_information, mock_properties, mock_payload)

    @listener.listen do |result|
      assert_kind_of Hopper::Message::Delivered, result
      assert_equal  result.message.payload, mock_payload
    end
  end

  test '#listen rejects on exception' do
    mock_delivery_information = mock
    mock_properties = mock
    mock_payload = mock
    
    @mock_queue_proxy.expects(:subscribe).yields(mock_delivery_information, mock_properties, mock_payload)

    mock_message = mock
    Hopper::Message::Delivered.expects(:new).returns(mock_message)

    mock_tag = mock
    mock_message.expects(:tag).returns(mock_tag)

    @listener.expects(:reject).with(mock_message)

    @listener.listen do |result|
      raise Exception
    end
  end

  test '#acknowledge' do
    mock_message = mock


    mock_tag = mock
    mock_message.expects(:tag).returns(mock_tag)

    @mock_channel.expects(:acknowledge).with(mock_tag)
    @mock_queue_proxy.expects(:channel).returns(@mock_channel)

    @listener.acknowledge(mock_message)
  end

  test '#retry' do
    mock_message = mock


    mock_tag = mock
    mock_message.expects(:tag).returns(mock_tag)

    @mock_channel.expects(:reject).with(mock_tag, true)
    @mock_queue_proxy.expects(:channel).returns(@mock_channel)

    @listener.retry(mock_message)
  end

  test '#reject' do
    mock_message = mock

    mock_tag = mock
    mock_message.expects(:tag).returns(mock_tag)

    @mock_channel.expects(:reject).with(mock_tag, false)
    @mock_queue_proxy.expects(:channel).returns(@mock_channel)

    @listener.reject(mock_message)
  end
end
