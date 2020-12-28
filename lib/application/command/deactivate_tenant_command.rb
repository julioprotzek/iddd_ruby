class DeactivateTenantCommand
  attr_accessor :tenant_id

  def initialize(tenant_id:)
    @tenant_id = tenant_id
  end
end