class AnotherTestableDomainEvent
  attr_reader :event_version, :occurred_at, :value

  def initialize(value)
    @event_version = 1
    @value = value
    @occurred_at = Time.now
  end
end