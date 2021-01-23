module RabbitMQ
  class NotificationPublisher
    def initialize(event_store, published_notification_tracker_store, message_locator)
      @event_store = event_store
      @published_notification_tracker_store = published_notification_tracker_store
      @exchange_name = message_locator
    end

    def publish_notifications
      published_notification_tracker = published_notification_tracker_store.published_notification_tracker

      notifications = list_unpublished_notifications(published_notification_tracker.most_recent_published_notification_id)

      for notification in notifications
        publish(notification, message_producer)
      end

      published_notification_tracker_store.track_most_recent_published_notification(
        published_notification_tracker,
        notifications
      )
    ensure
      message_producer.close
    end

    def internal_only_test_confirmation
      raise 'Not supported by production implementation.'
    end

    private

    def list_unpublished_notifications(most_recent_published_notification_id)
      stored_events = event_store.all_stored_events_since(most_recent_published_notification_id)
      notifications_from(stored_events)
    end

    def notifications_from(stored_events)
      stored_events.map do |stored_event|
        domain_event = stored_event.to_domain_event
        Notification.new(domain_event.id, domain_event)
      end
    end

    def message_producer
      # Creates my exchange if non-existing
      exchange = Exchange.fan_out_instance(
        connection_settings: ConnectionSettings.instance,
        name: exchange_name,
        durable: true
      )

      # Create a message producer used to forward events
      message_producer = MessageProducer.instance(exchange)

      message_producer
    end

    def publish(notification, message_producer)
      # TODO: where should this info go?
      # message_parameters = MessageParameters.durable_text_parameters(
      #   notification.type_name,
      #   notification.notification_id.to_s,
      #   notification.occurred_at
      # )

      content = NotificationSerializer.serialize(notification)
      message_producer.send(content)
    end

    attr_reader :event_store, :exchange_name, :published_notification_tracker_store
  end
end