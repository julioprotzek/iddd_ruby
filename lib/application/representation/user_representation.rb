class UserRepresentation
  attr_reader :email_address, :enabled, :first_name, :last_name, :tenant_id, :username

  def initialize(user)
    @email_address = user.person.email_address.address
    @enabled = user.enabled?
    @first_name = user.person.name.first_name
    @last_name = user.person.name.last_name
    @tenant_id = user.tenant_id.id
    @username = user.username
  end
end