class PublishedNotificationTracker
  include Assertion

  attr_reader :type_name
  attr_accessor :most_recent_published_notification_id, :published_notification_tracker_id

  def initialize(type_name)
    self.type_name = type_name
  end

  def type_name=(type_name)
    assert_presence(type_name, 'The tracker type name is required.')
    assert_length(type_name, 1, 100, 'The tracker type name must be 100 characters or less.')
    @type_name = type_name
  end
end