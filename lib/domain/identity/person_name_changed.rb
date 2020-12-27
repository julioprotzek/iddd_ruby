class PersonNameChanged
  attr_reader :version, :occurred_at, :username, :name

  def initialize(username, name)
    @version = 1
    @occurred_at = Time.now
    @username = username
    @name = name
  end
end