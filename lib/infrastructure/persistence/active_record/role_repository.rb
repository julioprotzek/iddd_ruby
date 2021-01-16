class ActiveRecord::RoleRepository

  def create(role)
    as_aggregate ActiveRecord::Role.create!(hash_from_aggregate(role))
  end

  def update(role)
    record = find_record_for(role)

    if record.present?
      record.update(hash_from_aggregate(role))
      as_aggregate(record)
    end
  end

  def all_roles(tenant_id)
    ActiveRecord::Role
      .where(tenant_id_id: tenant_id.id)
      .all
      .map{ |record| as_aggregate(record) }
  end

  def remove(role)
    ActiveRecord::Role.find_by(tenant_id_id: role.tenant_id.id).group.delete
  end

  def role_named(tenant_id, name)
    as_aggregate ActiveRecord::Role.find_by(tenant_id_id: tenant_id.id, name: name)
  end

  def clean
    ActiveRecord::Group.where(id: ActiveRecord::Role.select(:group_id)).delete_all
  end

  def reload(role)
    as_aggregate find_record_for(role)
  end

  private

  def as_aggregate(record)
    return unless record.present?

    role = Role.new(
      TenantId.new(record.tenant_id_id),
      record.name,
      record.description,
      record.supports_nesting
    )

    role.internal_group = group_as_aggregate(record.group)

    role
  end

  def hash_from_aggregate(role)
    role_hash = role.as_json.deep_symbolize_keys
    role_hash[:tenant_id_id] = role_hash.delete(:tenant_id)[:id]

    role_hash[:group][:tenant_id_id] = role_hash[:group].delete(:tenant_id)[:id]
    role_hash[:group][:members] = role_hash[:group][:members].map do |member_hash|
      member_hash[:tenant_id_id] = member_hash.delete(:tenant_id)[:id]
      member_hash[:member_type] = member_hash.delete(:type)

      member_record = ActiveRecord::Member.find_by(member_hash)

      member_record ||= ActiveRecord::Member.new(member_hash)

      member_record
    end

    group_record = ActiveRecord::Group.find_by(tenant_id_id: role_hash[:group][:tenant_id_id])

    if group_record.present?
      group_record.members = role_hash[:group][:members]
    else
      group_record = ActiveRecord::Group.new(role_hash[:group])
    end

    role_hash[:group] = group_record
    role_hash
  end

  def group_as_aggregate(record)
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

  def group_hash_from_aggregate(group)
    group_hash = group.as_json.deep_symbolize_keys
    group_hash[:tenant_id_id] = group_hash.delete(:tenant_id)[:id]

    group_hash[:members] = group_hash[:members].map do |member_hash|
      member_hash[:tenant_id_id] = member_hash.delete(:tenant_id)[:id]
      member_hash[:member_type] = member_hash.delete(:type)
      ActiveRecord::Member.new(member_hash)
    end

    group_hash
  end

  def find_record_for(role)
    ActiveRecord::Role.find_by(tenant_id_id: role.tenant_id.id, name: role.name)
  end
end