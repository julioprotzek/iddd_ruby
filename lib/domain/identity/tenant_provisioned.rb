class TenantProvisioned
  attr_reader :version, :occurred_at, :tenant_id

  def initialize(tenant_id)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = tenant_id
  end
end