class UserDescriptor
  include Assertion

  attr_reader :tenant_id, :username, :email_address

  def self.null_descriptor_instance
    NullUserDescriptor.new
  end

  def initialize(a_tenant_id, an_username, an_email_address)
    self.tenant_id = a_tenant_id
    self.username = an_username
    self.email_address = an_email_address
  end

  def tenant_id=(a_tenant_id)
    assert_presence(a_tenant_id, 'Tenant Id must be provided')
    @tenant_id = a_tenant_id
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

  def null_descriptor?
    false
  end
end