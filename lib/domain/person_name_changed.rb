class PersonNameChanged
  attr_reader :version, :occurred_at, :name

  def initialize(a_name)
    @version = 1
    @occurred_at = Time.now
    @name = a_name
  end
end