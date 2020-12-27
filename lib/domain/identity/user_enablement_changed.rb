class UserEnablementChanged
  attr_reader :version, :occurred_at, :username, :enablement

  def initialize(username:, enablement:)
    @version = 1
    @occurred_at = Time.now
    @username = username
    @enablement = enablement
  end
end