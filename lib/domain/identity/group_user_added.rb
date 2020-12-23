class GroupUserAdded
  attr_reader :version, :occurred_at, :tenant_id, :group_name, :username

  def initialize(a_tenant_id, a_group_name, an_username)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = a_tenant_id
    @group_name = a_group_name
    @username = an_username
  end
end