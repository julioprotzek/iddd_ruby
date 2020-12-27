class TestableDomainEvent
  attr_reader :event_version, :occurred_at, :id, :name

  def initialize(id, name)
    @event_version = 1
    @id = id
    @name = name
    @occurred_at = Time.now
  end
end
