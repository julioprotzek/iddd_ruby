module RabbitMQ
  # Facilitates sending messages to a BrokerChannel.
  # A BrokerChannel may be either an Exchange or a Queue
  class MessageProducer
    def self.instance(broker_channel)
      MessageProducer.new(broker_channel)
    end

    attr_reader :broker_channel

    def initialize(broker_channel)
      @broker_channel = broker_channel
    end

    def close
      broker_channel.close
    end

    def send(text_message, routing_key: nil)
      options = {
        persistent: broker_channel.durable?,
        routing_key: routing_key
      }

      broker_channel.publish(text_message, options)
    rescue => error
      raise MessageError.new(message: 'Failed to send message to channel.', cause: error)
    ensure
      # Allow for sending message bursts
      self
    end

    # Check parameters for validity
    def check(message_parameters)
      raise ArgumentError, 'Message parameters must be durable.' if broker_channel.durable? && !message_parameters.durable?
      raise ArgumentError, 'Message parameters must not be durable.' if !broker_channel.durable? && message_parameters.durable?
    end
  end
end