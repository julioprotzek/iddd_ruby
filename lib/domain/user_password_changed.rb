class UserPasswordChanged
  attr_reader :version, :occurred_at, :username

  def initialize(a_username)
    @version = 1
    @occurred_at = Time.now
    @username = a_username
  end
end