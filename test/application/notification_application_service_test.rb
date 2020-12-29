require './test/application/application_service_test'

class NotificationApplicationServiceTest < ApplicationServiceTest
  extend Minitest::Spec::DSL

  let(:notification_application_service) { ApplicationServiceRegistry.notification_application_service }
  let(:event_store) { notification_application_service.event_store }
  let(:notification_publisher) { notification_application_service.notification_publisher }

  setup do
    (1..30).each do |id|
      event_store.append(TestableDomainEvent.new(id: id, name: "Event #{id}"))
    end
  end

  test 'current notification log' do
    log = notification_application_service.current_notification_log

    assert NotificationLogFactory.notifications_per_log >= log.total_notifications
    assert event_store.count_stored_events >= log.total_notifications
    assert !log.has_next_notification_log?
    assert log.has_previous_notification_log?
    assert !log.archived?
  end

  test 'notification log' do
    id = NotificationLogId.first(NotificationLogFactory.notifications_per_log)

    log = notification_application_service.notification_log(id.encoded)

    assert_equal log.total_notifications, NotificationLogFactory.notifications_per_log
    assert log.total_notifications <= event_store.count_stored_events
    assert log.has_next_notification_log?
    assert !log.has_previous_notification_log?
    assert log.archived?
  end

  test 'publish notifications' do
    notification_application_service.publish_notifications
    assert notification_publisher.internal_only_test_confirmation
  end
end