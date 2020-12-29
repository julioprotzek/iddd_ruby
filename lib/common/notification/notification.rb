class Notification
  include Assertion

  attr_reader :event, :notification_id, :occurred_at, :type_name, :version

  def initialize(notification_id, event)
    self.event = event
    @notification_id = notification_id
    @occurred_at = event.occurred_at
    self.type_name = event.class.name
    @version = event.version
  end

  def event=(event)
    assert_presence(event, 'The event is required.')

    @event = event
  end

  def type_name=(type_name)
    assert_presence(type_name, 'The type name is required.')
    assert_length(type_name, 1, 100, 'The type name must be 100 characters or less.')

    @type_name = type_name
  end
end