class ActiveRecord::GroupRepository
  class GroupModel < ActiveRecord::Base
    has_many :members, class_name: 'MemberModel', foreign_key: 'group_id'
    self.table_name = 'groups'
    validates :name, uniqueness: { scope: :tenant_id_id }
  end

  class MemberModel < ActiveRecord::Base
    belongs_to :group, class_name: 'GroupModel', foreign_key: 'group_id'
    self.table_name = 'group_members'
  end

  def add(group)
    record = find_record_for(group)

    if record.present?
      record.update(hash_from_aggregate(group))
    else
      record = GroupModel.create!(hash_from_aggregate(group))
    end

    as_aggregate(record)
  rescue
    raise StandardError, 'Group is not unique.'
  end

  def all_groups(tenant_id)
    GroupModel.where(tenant_id_id: tenant_id.id).map do |record|
      as_aggregate(record)
    end
  end

  def group_named(tenant_id, name)
    raise ArgumentError, 'May not find internal groups.' if name.starts_with?(Group::ROLE_GROUP_PREFIX)
    record = GroupModel.find_by(tenant_id_id: tenant_id.id, name: name)
    if record.present?
      as_aggregate(record)
    end
  end

  def remove(group)
    GroupModel.find_by(tenant_id_id: group.tenant_id.id, name: group.name).delete
    group
  end

  def clean
    GroupModel.delete_all
  end

  def reload(group)
    record = find_record_for(group)
    return unless record.present?

    as_aggregate(record)
  end

  private

  def as_aggregate(record)
    group = Group.new(TenantId.new(record.tenant_id_id), record.name, record.description)

    group.members = record.members.to_a.map do |member_record|
      GroupMember.new(
        tenant_id: TenantId.new(member_record.tenant_id_id),
        name: member_record.name,
        type: member_record.member_type
      )
    end

    group
  end

  def hash_from_aggregate(group)
    group_hash = group.as_json.deep_symbolize_keys
    group_hash[:tenant_id_id] = group_hash.delete(:tenant_id)[:id]

    group_hash[:members] = group_hash[:members].map do |member_hash|
      member_hash[:tenant_id_id] = member_hash.delete(:tenant_id)[:id]
      member_hash[:member_type] = member_hash.delete(:type)
      MemberModel.new(member_hash)
    end

    group_hash
  end

  def find_record_for(group)
    GroupModel.find_by(tenant_id_id: group.tenant_id.id, name: group.name)
  end
end