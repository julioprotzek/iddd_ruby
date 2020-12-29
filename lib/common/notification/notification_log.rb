class NotificationLog
  attr_reader :notification_log_id, :next_notification_log_id, :previous_notification_log_id

  def initialize(notification_log_id:, next_notification_log_id:, previous_notification_log_id:, notifications: [], archived:)
    @notification_log_id = notification_log_id
    @next_notification_log_id = next_notification_log_id
    @previous_notification_log_id = previous_notification_log_id
    @notifications = notifications
    @archived = archived
  end

  def archived?
    @archived
  end

  def notifications
    @notifications.freeze
  end

  def decoded_notification_log_id
    NotificationLogId.new(notification_log_id)
  end

  def decoded_next_notification_log_id
    NotificationLogId.new(next_notification_log_id)
  end

  def has_next_notification_log?
    next_notification_log_id.present?
  end

  def decoded_previous_notification_log_id
    NotificationLogId.new(previous_notification_log_id)
  end

  def has_previous_notification_log?
    previous_notification_log_id.present?
  end

  def total_notifications
    notifications.size
  end
end