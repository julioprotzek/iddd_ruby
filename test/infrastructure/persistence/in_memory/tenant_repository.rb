class InMemory::TenantRepository
  def initialize
    @repository = {}
  end

  def create(tenant)
    raise StandardError, 'Validation failed: Name has already been taken' if @repository.key?(key_of(tenant))
    @repository[key_of(tenant)] = tenant
  end

  def update(tenant)
    @repository[key_of(tenant)] = tenant
  end

  def next_identity
    TenantId.new(SecureRandom.uuid)
  end

  def tenant_named(name)
    @repository.values.find{ |tenant| tenant.name == name }
  end

  def tenant_of_id(tenant_id)
    @repository[tenant_id.id]
  end

  def remove(tenant)
    @repository.delete(key_of(tenant))
  end

  def clean
    @repository.clear
  end

  private

  def key_of(tenant)
    tenant.tenant_id.id
  end
end