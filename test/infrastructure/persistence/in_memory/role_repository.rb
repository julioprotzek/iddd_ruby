class InMemory::RoleRepository
  def initialize
    @repository = {}
  end

  def create(role)
    key = key_of(role)
    raise StandardError, 'Validation failed: Name has already been taken' if @repository.key?(key)
    @repository[key] = role
  end

  def update(role)
    @repository[key_of(role)] = role
  end

  def all_roles(tenant_id)
    @repository.values.select{ |role| role.tenant_id == tenant_id }
  end

  def remove(role)
    @repository.delete(key_of(role))
  end

  def role_named(tenant_id, role_name)
    @repository[key_with(tenant_id, role_name)]
  end

  def clean
    @repository.clear
  end

  def reload(role)
    @repository[key_of(role)]
  end

  private

  def key_of(role)
    key_with(role.tenant_id, role.name)
  end

  def key_with(tenant_id, role_name)
    "#{tenant_id.id}##{role_name}"
  end
end