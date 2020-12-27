class UserPasswordChanged
  attr_reader :version, :occurred_at, :username

  def initialize(username:)
    @version = 1
    @occurred_at = Time.now
    @username = username
  end
end