class InMemoryGroupRepository
  def initialize
    @repository = {}
  end

  def add(a_group)
    key = key_of(a_group)
    raise StandardError, 'Duplicate Key' if @repository.key?(key)
    @repository[key] = a_group
  end

  def all_groups(tenant_id)
    @repository.values.select{ |a_group| a_group.tenant_id == tenant_id }
  end

  def group_named(a_tenant_id, a_name)
    raise ArgumentError, 'May not find internal groups.' if a_name.starts_with?(Group::ROLE_GROUP_PREFIX)
    @repository[key_with(a_tenant_id, a_name)]
  end

  def remove(a_group)
    @repository.delete(key_of(a_group))
  end

  def clean
    @repository.clear
  end

  private

  def key_of(a_group)
    key_with(a_group.tenant_id, a_group.name)
  end

  def key_with(tenant_id, a_name)
    "#{tenant_id}##{a_name}"
  end
end