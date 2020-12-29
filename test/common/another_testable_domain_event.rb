class AnotherTestableDomainEvent
  attr_reader :version, :occurred_at, :value

  def initialize(value:)
    @version = 1
    @value = value
    @occurred_at = Time.now
  end
end