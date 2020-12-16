class TestableDomainEvent
  attr_reader :event_version, :occurred_at, :id, :name

  def initialize(an_id, a_name)
    @event_version = 1
    @id = an_id
    @name = a_name
    @occurred_at = Time.now
  end
end
