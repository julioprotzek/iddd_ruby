class GroupGroupAdded
  attr_reader :version, :occurred_at, :tenant_id, :group_name, :nested_group_name

  def initialize(tenant_id, group_name, nested_group_name)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = tenant_id
    @group_name = group_name
    @nested_group_name = nested_group_name
  end
end