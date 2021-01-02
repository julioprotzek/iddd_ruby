class InMemory::GroupRepository
  def initialize
    @repository = {}
  end

  def add(group)
    key = key_of(group)
    raise StandardError, 'Duplicate Key' if @repository.key?(key)
    @repository[key] = group
  end

  def all_groups(tenant_id)
    @repository.values.select{ |group| group.tenant_id == tenant_id }
  end

  def group_named(tenant_id, name)
    raise ArgumentError, 'May not find internal groups.' if name.starts_with?(Group::ROLE_GROUP_PREFIX)
    @repository[key_with(tenant_id, name)]
  end

  def remove(group)
    @repository.delete(key_of(group))
  end

  def clean
    @repository.clear
  end

  private

  def key_of(group)
    key_with(group.tenant_id, group.name)
  end

  def key_with(tenant_id, name)
    "#{tenant_id.id}##{name}"
  end
end