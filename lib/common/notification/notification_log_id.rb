class NotificationLogId
  class << self
    def first(notifications_per_log)
      id = NotificationLogId.from(0, 0)
      id.next(notifications_per_log)
    end

    def from(low, high)
      NotificationLogId.new("#{low},#{high}")
    end
  end

  attr_reader :low, :high

  def initialize(notification_log_id)
    text_ids = notification_log_id.split(',')
    @low = text_ids.first.to_i
    @high = text_ids.last.to_i
  end

  def encoded
    "#{low},#{high}"
  end

  def next(notifications_per_log)
    next_low = high + 1

    # ensures a minted id value even though there may
    # not be this many notifications at present
    next_high = next_low + notifications_per_log - 1

    next_log_id = NotificationLogId.from(next_low, next_high)

    next_log_id = nil if next_log_id == self

    next_log_id
  end

  def previous(notifications_per_log)
    previous_low = [low - notifications_per_log, 1].max
    previous_high = previous_low + notifications_per_log - 1

    previous_log_id = NotificationLogId.from(previous_low, previous_high)

    previous_log_id = nil if previous_log_id == self

    previous_log_id
  end

  def ==(other)
    self.class == other.class &&
    self.low == other.low &&
    self.high == other.high
  end
end