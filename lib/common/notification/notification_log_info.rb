class NotificationLogInfo
  attr_reader :notification_log_id, :total_logged

  def initialize(notification_log_id, total_logged)
    @notification_log_id = notification_log_id
    @total_logged = total_logged
  end
end