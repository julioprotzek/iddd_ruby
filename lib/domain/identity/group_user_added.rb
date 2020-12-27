class GroupUserAdded
  attr_reader :version, :occurred_at, :tenant_id, :group_name, :username

  def initialize(tenant_id, group_name, username)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = tenant_id
    @group_name = group_name
    @username = username
  end
end