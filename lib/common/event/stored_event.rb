class StoredEvent
  include Assertion

  attr_reader :event_id, :occurred_at, :event_body, :type_name

  def initialize(type_name:, occurred_at:, event_body:, event_id: -1)
    self.type_name = type_name
    @occurred_at = occurred_at
    self.event_body = event_body
    @event_id = event_id
  end

  def to_domain_event
    EventSerializer.deserialize(event_body, type_name)
  end

  def event_body=(event_body)
    assert_presence(event_body, 'The event body is required.')
    assert_length(event_body, 1, 65000, 'The event body must be 65000 characters or less.')

    @event_body = event_body
  end

  def type_name=(type_name)
    assert_presence(type_name, 'The event type name is required.')
    assert_length(type_name, 1, 100, 'The event type name must be 65000 characters or less.')

    @type_name = type_name
  end
end