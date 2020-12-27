class RoleProvisioned
  attr_reader :version, :occurred_at, :tenant_id, :name

  def initialize(tenant_id:, name:)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = tenant_id
    @name = name
  end
end