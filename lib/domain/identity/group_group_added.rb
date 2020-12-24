class GroupGroupAdded
  attr_reader :version, :occurred_at, :tenant_id, :group_name, :nested_group_name

  def initialize(a_tenant_id, a_group_name, a_nested_group_name)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = a_tenant_id
    @group_name = a_group_name
    @nested_group_name = a_nested_group_name
  end
end