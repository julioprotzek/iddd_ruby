class ActiveRecord::GroupRepository
  def create(group)
    as_aggregate ActiveRecord::Group.create!(hash_from_aggregate(group))
  rescue ActiveRecord::RecordInvalid => error
    raise StandardError, error.message
  end

  def update(group)
    record = find_record_for(group)
    record.update(hash_from_aggregate(group))
    as_aggregate(record)
  rescue ActiveRecord::RecordInvalid => error
    raise StandardError, error.message
  end

  def all_groups(tenant_id)
    ActiveRecord::Group.where(tenant_id_id: tenant_id.id).map do |record|
      as_aggregate(record)
    end
  end

  def group_named(tenant_id, name)
    raise ArgumentError, 'May not find internal groups.' if name.starts_with?(Group::ROLE_GROUP_PREFIX)
    record = ActiveRecord::Group.find_by(tenant_id_id: tenant_id.id, name: name)
    if record.present?
      as_aggregate(record)
    end
  end

  def remove(group)
    ActiveRecord::Group.find_by(tenant_id_id: group.tenant_id.id, name: group.name).delete
    group
  end

  def clean
    ActiveRecord::Group.delete_all
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
      ActiveRecord::Member.new(member_hash)
    end

    group_hash
  end

  def find_record_for(group)
    ActiveRecord::Group.find_by(tenant_id_id: group.tenant_id.id, name: group.name)
  end
end