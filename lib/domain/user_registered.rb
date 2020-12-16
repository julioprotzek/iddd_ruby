class UserRegistered
  attr_reader :version, :occurred_at, :username, :name, :email_address

  def initialize(an_username, a_name, an_email_address)
    @version = 1
    @occurred_at = Time.now
    @username = an_username
    @name = a_name
    @email_address = an_email_address
  end
end