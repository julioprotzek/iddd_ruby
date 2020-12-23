class PersonNameChanged
  attr_reader :version, :occurred_at, :username, :name

  def initialize(an_username, a_name)
    @version = 1
    @occurred_at = Time.now
    @username = an_username
    @name = a_name
  end
end