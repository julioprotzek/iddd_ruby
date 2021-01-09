class AssignGroupToRoleCommand
  attr_reader :tenant_id, :group_name, :role_name

  def initialize(tenant_id:, group_name:, role_name:)
    @tenant_id = tenant_id
    @group_name = group_name
    @role_name = role_name
  end
end
