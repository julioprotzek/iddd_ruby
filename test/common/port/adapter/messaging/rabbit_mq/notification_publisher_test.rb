require './test/test_helper'

module RabbitMQ
  class NotificationPublisherTest < ActiveSupport::TestCase
    EXCHANGE_NAME = 'unit.test'

    setup do
      DomainEventPublisher.reset
      event_store.clean

      starting_domain_event_id = Time.now.to_i

      (1..30).each do |id|
        domain_event_id = starting_domain_event_id + 1

        event_store.append(
          TestableDomainEvent.new(
            id: domain_event_id,
            name: "Event #{domain_event_id}"
          )
        )
      end
    end

    test 'publish notifications' do
      published_notification_tracker_store = ActiveRecord::PublishedNotificationTrackerStore.new(EXCHANGE_NAME)

      notification_publisher = RabbitMQ::NotificationPublisher.new(
        event_store,
        published_notification_tracker_store,
        EXCHANGE_NAME
      )

      notification_publisher.publish_notifications
    end

    def event_store
      @event_store ||= ActiveRecord::EventStore.new
    end
  end
end