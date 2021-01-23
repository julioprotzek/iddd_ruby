class ActiveRecord::PublishedNotificationTrackerStore

  class StoredPublishedNotificationTracker < ActiveRecord::Base
    self.table_name = 'published_notification_trackers'
  end

  attr_reader :type_name

  def initialize(published_notification_tracker_type)
    @type_name = published_notification_tracker_type
  end

  def published_notification_tracker(type_name = nil)
    record = StoredPublishedNotificationTracker.find_by(type_name: type_name || self.type_name)

    if record.present?
      tracker = PublishedNotificationTracker.new(record.type_name)
      tracker.most_recent_published_notification_id = record.most_recent_published_notification_id
      tracker.published_notification_tracker_id = record.id
      tracker
    else
      PublishedNotificationTracker.new(type_name || self.type_name)
    end
  end

  def track_most_recent_published_notification(published_notification_tracker, notifications)
    last_index = notifications.size - 1

    if last_index >= 0
      most_recent_id = notifications[last_index].notification_id
      published_notification_tracker.most_recent_published_notification_id = most_recent_id
      save(published_notification_tracker)
    end

    nil
  end

  private

  def save(tracker)
    StoredPublishedNotificationTracker.new(
      id: tracker.published_notification_tracker_id,
      type_name: tracker.type_name,
      most_recent_published_notification_id: tracker.most_recent_published_notification_id,
    ).save
  end

end