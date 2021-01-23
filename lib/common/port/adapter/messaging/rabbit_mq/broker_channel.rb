require 'bunny'

module RabbitMQ
  class BrokerChannel
    attr_reader :host, :name, :connection

    def initialize(connection_settings:, name: nil)
      @name = name
      @connection = new_connection_using(connection_settings)
      @channel = @connection.create_channel
      @host = host
    rescue => error
      pp error
      raise MessageError.new(message: "Failed to create/open the queue.", cause: error)
    end

    def publish(*args)
      @producer.publish(*args)
    end

    def close
      # RabbitMQ doesn't guarantee that if .open? returns true that close() will work
      # because another client may be racing to close the same process and/or components.
      # So here just attempt to close, catch and ignore, and move on to the next steps
      # is the recommended approach.
      #
      # For the purporse here, the .open? checks prevents closing a shared channel and
      # connection that is shared by a subscriber exchange and queue.

      begin
        channel.close if channel.present? && channel.open?
      rescue
        # fall through
      end

      begin
        connection.close if connection.present? && connection.open?
      rescue
        # fall through
      end

      @channel = nil
      @connection = nil
    end

    def durable?
      @durable
    end

    def exchange?
      false
    end

    def exchange_name
      self.exchange? ? name : ''
    end

    def queue?
      false
    end

    def queue_name
      self.queue? ? name : ''
    end

    private

    def producer=(queue_or_exchange)
      raise NotImplmentedError, 'BrokerChannel is an abstract class, use either Exchange or Queue'
    end

    def new_connection_using(connection_settings)
      options = {
        host: connection_settings.host,
        vhost: connection_settings.vhost,
      }

      options[:port] = connection_settings.port if connection_settings.has_port?

      if connection_settings.has_user_credentials?
        options[:username] = connection_settings.username
        options[:password] = connection_settings.password
      end

      connection = Bunny.new(options)
      connection.start
      connection
    end

    attr_reader :channel, :connection_settings
    attr_writer :durable
  end
end