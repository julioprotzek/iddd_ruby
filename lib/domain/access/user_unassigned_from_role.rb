class UserUnassignedFromRole
  attr_reader :version, :occurred_at, :tenant_id, :role_name, :username

  def initialize(tenant_id, role_name, username)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = tenant_id
    @role_name = role_name
    @username = username
  end
end