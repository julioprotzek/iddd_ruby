class ActiveRecord::GroupRepository
  class Repository < ActiveRecord::Base
    self.table_name = 'groups'
    validates :name, uniqueness: { scope: :tenant_id_id }
  end

  def add(group)
    Repository.create!(from_aggregate(group))
  rescue
    raise StandardError, 'Group is not unique.'
  end

  def all_groups(tenant_id)
    Repository.where(tenant_id_id: tenant_id.id).map do |record|
      to_aggregate record
    end
  end

  def group_named(tenant_id_id, name)
    raise ArgumentError, 'May not find internal groups.' if name.starts_with?(Group::ROLE_GROUP_PREFIX)
    Repository.find_by(tenant_id_id: tenant_id_id, name: name)
  end

  def remove(group)
    Repository.group_named(group.tenant_id.id, group.name).delete
  end

  def clean
    Repository.delete_all
  end

  private

  def to_aggregate(record)
    Group.new(TenantId.new(record.tenant_id_id), record.name, record.description)
  end

  def from_aggregate(group)
    group_hash = group.as_json.deep_symbolize_keys
    group_hash[:tenant_id_id] = group_hash[:tenant_id][:id]
    group_hash.delete(:tenant_id)
    group_hash.delete(:members) # Todo: Implement members
    group_hash
  end
end