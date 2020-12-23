class InMemoryTenantRepository
  def initialize
    @repository = {}
  end

  def add(a_tenant)
    key = key_of(a_tenant)
    raise StandardError, 'Duplicate Key' if @repository.key?(key)
    @repository[key] = a_tenant
  end

  def next_identity
    TenantId.new(SecureRandom.uuid)
  end

  def tenant_named(a_name)
    @repository.values.find{ |a_tenant| a_tenant.name == a_name }
  end

  def tenant_of_id(a_tenant_id)
    @repository[a_tenant_id]
  end

  def remove(a_tenant)
    @repository.delete(key_of(a_tenant))
  end

  def clean
    @repository.clear
  end

  private

  def key_of(a_tenant)
    a_tenant.tenant_id
  end
end