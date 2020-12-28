class ChangeEmailAddressCommand
  attr_accessor :tenant_id, :username, :email_address

  def initialize(tenant_id:, username:, email_address:)
    @tenant_id = tenant_id
    @username = username
    @email_address = email_address
  end
end