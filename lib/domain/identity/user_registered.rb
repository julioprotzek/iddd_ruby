class UserRegistered
  attr_reader :version, :occurred_at, :username, :name, :email_address

  def initialize(username:, name:, email_address:)
    @version = 1
    @occurred_at = Time.now
    @username = username
    @name = name
    @email_address = email_address
  end
end