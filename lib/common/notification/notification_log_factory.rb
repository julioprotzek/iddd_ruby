class NotificationLogFactory
  # this could be a configuration
  NOTIFICATIONS_PER_LOG = 20

  def self.notifications_per_log
    NOTIFICATIONS_PER_LOG
  end

  def initialize(an_event_store)
    @event_store = an_event_store
  end

  def create_current_notification_log
    create_notification_log_from(calculate_current_notification_log_id(event_store))
  end

  def create_notification_log(notification_log_id)
    count = event_store.count_stored_events
    info = NotificationLogInfo.new(notification_log_id, count)
    create_notification_log_from(info)
  end

  private

  attr_reader :event_store

  def calculate_current_notification_log_id(an_event_store)
    count = an_event_store.count_stored_events
    remainder = count % NOTIFICATIONS_PER_LOG

    if remainder == 0 && count > 0
      remainder = NOTIFICATIONS_PER_LOG
    end

    low = count - remainder + 1

    # ensures a minted id value even though there may
    # not be a full set of notifications at present
    high = low + NOTIFICATIONS_PER_LOG - 1

    NotificationLogInfo.new(NotificationLogId.from(low, high), count)
  end

  def create_notification_log_from(notification_log_info)
    stored_events = event_store.all_stored_events_between(
      notification_log_info.notification_log_id.low,
      notification_log_info.notification_log_id.high
    )

    archived = notification_log_info.notification_log_id.high < notification_log_info.total_logged

    next_log_id = archived ? notification_log_info.notification_log_id.next(NOTIFICATIONS_PER_LOG) : nil

    previous_log_id = notification_log_info.notification_log_id.previous(NOTIFICATIONS_PER_LOG)

    NotificationLog.new(
      notification_log_id: notification_log_info.notification_log_id&.encoded,
      next_notification_log_id: next_log_id&.encoded,
      previous_notification_log_id: previous_log_id&.encoded,
      notifications: notifications_from(stored_events),
      archived: archived
    )
  end

  def notifications_from(stored_events)
    stored_events.map do |stored_event|
      Notification.new(stored_event.event_id, stored_event.to_domain_event)
    end
  end
end