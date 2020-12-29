class TestableDomainEvent
  attr_reader :version, :occurred_at, :id, :name

  def initialize(id:, name:)
    @version = 1
    @id = id
    @name = name
    @occurred_at = Time.now
  end
end
