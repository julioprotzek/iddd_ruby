module RabbitMQ
  # Simplifies RabbitMQ exchanges
  class Exchange < BrokerChannel
    class << self
      def direct_instance(connection_settings:, name:, durable:)
        Exchange.new(connection_settings, name, :direct, durable)
      end

      def fan_out_instance(connection_settings:, name:, durable:)
        Exchange.new(connection_settings, name, :fanout, durable)
      end

      def headers_instance(connection_settings:, name:, durable:)
        Exchange.new(connection_settings, name, :headers, durable)
      end

      def topic_instance(connection_settings:, name:, durable:)
        Exchange.new(connection_settings, name, :topic, durable)
      end
    end

    def initialize(connection_settings, name, type, durable)
      super(connection_settings: connection_settings, name: name)
      self.durable = durable
      @type = type
      @producer = channel.send(type, name)
    rescue => error
      raise MessageError.new(message: 'Failed to create/open the exchange.', cause: error)
    end

    private

    def exchange?
      true
    end

    attr_reader :type
  end
end