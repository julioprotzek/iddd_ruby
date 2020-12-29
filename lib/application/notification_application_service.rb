class NotificationApplicationService
  attr_reader :event_store, :notification_publisher

  def initialize(event_store, notification_publisher)
    @event_store = event_store
    @notification_publisher = notification_publisher
  end

  def current_notification_log
    factory = NotificationLogFactory.new(event_store)
    factory.create_current_notification_log
  end

  def notification_log(notification_log_id)
    factory = NotificationLogFactory.new(event_store)
    factory.create_notification_log(NotificationLogId.new(notification_log_id))
  end

  def publish_notifications
    notification_publisher.publish_notifications
  end
end