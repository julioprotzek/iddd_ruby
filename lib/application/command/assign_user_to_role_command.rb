class AssignUserToRoleCommand
  attr_reader :tenant_id, :username, :role_name

  def initialize(tenant_id:, username:, role_name:)
    @tenant_id = tenant_id
    @username = username
    @role_name = role_name
  end
end