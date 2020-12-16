class AnotherTestableDomainEvent
  attr_reader :event_version, :occurred_at, :value

  def initialize(a_value)
    @event_version = 1
    @value = a_value
    @occurred_at = Time.now
  end
end