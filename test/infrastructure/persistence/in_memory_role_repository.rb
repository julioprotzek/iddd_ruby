class InMemoryRoleRepository
  def initialize
    @repository = {}
  end

  def add(a_role)
    key = key_of(a_role)
    raise StandardError, 'Duplicate Key' if @repository.key?(key)
    @repository[key] = a_role
  end

  def remove(a_role)
    @repository.delete(key_of(a_role))
  end

  def clean
    @repository.clear
  end

  private

  def key_of(a_role)
    "#{a_role.tenant_id}##{a_role.name}"
  end
end