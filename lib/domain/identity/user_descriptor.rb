class UserDescriptor
  include Assertion

  attr_reader :username, :email_address

  def initialize(an_username, an_email_address)
    self.username = an_username
    self.email_address = an_email_address
  end

  def username=(an_username)
    assert_presence(an_username, 'Username must be provided')
    @username = an_username
  end

  def email_address=(an_email_address)
    assert_presence(an_email_address, 'Email address must be provided')
    @email_address = an_email_address
  end

  def ==(other)
    self.class == other.class &&
    self.username == other.username &&
    self.email_address == other.email_address
  end
end