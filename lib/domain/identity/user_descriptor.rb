class UserDescriptor
  include Assertion

  attr_reader :tenant_id, :username, :email_address

  def self.null_descriptor_instance
    NullUserDescriptor.new
  end

  def initialize(tenant_id, username, email_address)
    self.tenant_id = tenant_id
    self.username = username
    self.email_address = email_address
  end

  def ==(other)
    self.class == other.class &&
    self.username == other.username &&
    self.email_address == other.email_address
  end

  def null_descriptor?
    false
  end

  private

  def tenant_id=(tenant_id)
    assert_presence(tenant_id, 'Tenant Id must be provided')
    @tenant_id = tenant_id
  end

  def username=(username)
    assert_presence(username, 'Username must be provided')
    @username = username
  end

  def email_address=(email_address)
    assert_presence(email_address, 'Email address must be provided')
    @email_address = email_address
  end
end