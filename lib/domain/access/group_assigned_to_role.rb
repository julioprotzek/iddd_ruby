class GroupAssignedToRole
  attr_reader :version, :occurred_at, :tenant_id, :role_name, :group_name

  def initialize(tenant_id, role_name, group_name)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = tenant_id
    @role_name = role_name
    @group_name = group_name
  end
end