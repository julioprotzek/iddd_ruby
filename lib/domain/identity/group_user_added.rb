class GroupUserAdded
  attr_reader :version, :occurred_at, :username

  def initialize(an_username)
    @version = 1
    @occurred_at = Time.now
    @username = an_username
  end
end