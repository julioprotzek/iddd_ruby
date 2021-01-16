class UserInRoleRepresentation
  attr_reader :email_address, :role, :first_name, :last_name, :tenant_id, :username

  def initialize(user, role_name)
    @email_address = user.person.email_address.address
    @role = role_name
    @first_name = user.person.name.first_name
    @last_name = user.person.name.last_name
    @tenant_id = user.tenant_id.id
    @username = user.username
  end
end