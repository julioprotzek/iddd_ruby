class UserEnablementChanged
  attr_reader :version, :occurred_at, :username, :enablement

  def initialize(an_username, an_enablement)
    @version = 1
    @occurred_at = Time.now
    @username = an_username
    @enablement = an_enablement
  end
end