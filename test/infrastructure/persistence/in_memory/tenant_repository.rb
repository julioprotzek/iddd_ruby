class InMemory::TenantRepository
  def initialize
    @repository = {}
  end

  def add(tenant)
    key = key_of(tenant)
    raise StandardError, 'Duplicate Key' if @repository.key?(key)
    @repository[key] = tenant
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