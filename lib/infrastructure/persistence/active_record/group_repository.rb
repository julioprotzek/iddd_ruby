class ActiveRecord::GroupRepository
  class Repository < ActiveRecord::Base
    self.table_name = 'groups'
    validates_uniqueness_of :key
  end

  def add(group)
    key = key_of(group)
    raise StandardError, 'Duplicate Key' if Repository.find_by(key: key)
    Repository.create!(from_aggregate(group))
  end

  def all_groups(tenant_id)
    Repository.where(tenant_id: tenant_id.id).map do |record|
      to_aggregate record
    end
  end

  def group_named(tenant_id, name)
    raise ArgumentError, 'May not find internal groups.' if name.starts_with?(Group::ROLE_GROUP_PREFIX)
    Repository.find_by(tenant_id: tenant_id, name: name)
  end

  def remove(group)
    Repository.find_by(key: key_of(group)).delete
  end

  def clean
    Repository.delete_all
  end

  private

  def key_of(group)
    key_with(group.tenant_id, group.name)
  end

  def key_with(tenant_id, name)
    "#{tenant_id.id}##{name}"
  end

  def to_aggregate(record)
    Group.new(TenantId.new(record.tenant_id), record.name, record.description)
  end

  def from_aggregate(group)
    group_hash = group.as_json.deep_symbolize_keys
    group_hash[:tenant_id] = group_hash[:tenant_id][:id]
    group_hash[:key] = key_of(group)
    group_hash.delete(:members) # Todo: Implement members
    group_hash
  end
end