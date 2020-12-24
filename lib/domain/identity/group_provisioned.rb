class GroupProvisioned
  attr_reader :version, :occurred_at, :tenant_id, :name

  def initialize(a_tenant_id, a_name)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = a_tenant_id
    @name = a_name
  end
end