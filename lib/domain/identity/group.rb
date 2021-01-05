class Group
  include Assertion

  ROLE_GROUP_PREFIX = 'ROLE-INTERNAL-GROUP: '

  attr_reader :tenant_id, :name, :description, :members

  def initialize(tenant_id, name, description)
    self.tenant_id = tenant_id
    self.name = name
    self.description = description
    @members = SetList.new
  end

  def add_group(group, group_member_service)
    assert_presence(group, 'Group must be provided.')
    assert_equal(tenant_id, group.tenant_id, 'Wrong tenant for this group.')
    assert(!group_member_service.member_group?(group, self), 'Group recursion.')

    if members.add?(group.as_member) && !internal_group?
      DomainEventPublisher.publish(
        GroupGroupAdded.new(
          tenant_id: tenant_id,
          group_name: name,
          nested_group_name: group.name
        )
      )
    end
  end

  def add_user(user)
    assert_presence(user, 'User must be provided.')
    assert_equal(tenant_id, user.tenant_id, 'Wrong tenant for this group.')
    assert(user.enabled?, 'User is not enabled.')

    if members.add?(user.as_member) && !internal_group?
      DomainEventPublisher.publish(
        GroupUserAdded.new(
          tenant_id: tenant_id,
          group_name: name,
          username: user.username
        )
      )
    end
  end

  def member?(user, group_member_service)
    assert_presence(user, 'User must be provided.')
    assert_equal(tenant_id, user.tenant_id, 'Wrong tenant for this group.')
    assert(user.enabled?, 'User is not enabled.')

    if user.as_member.in?(members)
      return group_member_service.confirm_user(self, user)
    else
      return group_member_service.in_nested_group?(self, user)
    end
  end

  def remove_group(group)
    assert_presence(group, 'Group must be provided.')
    assert_equal(tenant_id, group.tenant_id, 'Wrong tenant for this group.')

    # Not a nested remove, only a direct member
    if members.delete?(group.as_member) && !internal_group?
      DomainEventPublisher.publish(
        GroupGroupRemoved.new(
          tenant_id: tenant_id,
          group_name: name,
          nested_group_name: group.name
        )
      )
    end
  end

  def remove_user(user)
    assert_presence(user, 'User must be provided.')
    assert_equal(tenant_id, user.tenant_id, 'Wrong tenant for this group.')

    # Not a nested remove, only a direct member
    if members.delete?(user.as_member) && !internal_group?
      DomainEventPublisher.publish(
        GroupUserRemoved.new(
          tenant_id: tenant_id,
          group_name: name,
          username: user.username
        )
      )
    end
  end

  def ==(other)
    self.class == other.class &&
    self.tenant_id == other.tenant_id &&
    self.name == other.name
  end

  def eql?(other)
    self == other
  end

  def as_member
    GroupMember.new(
      tenant_id: tenant_id,
      name: name,
      type: self.class.name
    )
  end

  def members=(members)
    @members = SetList.new(members)
  end

  private

  def tenant_id=(tenant_id)
    assert_presence(tenant_id, 'The Tenant Id must be provided.')
    @tenant_id = tenant_id
  end

  def description=(description)
    assert_presence(description, 'Group description is required.')
    assert_length(description, 1, 250, 'Group description must be 250 characters or less.')

    @description = description
  end

  def name=(name)
    assert_presence(name, 'Group name is required.')
    assert_length(name, 1, 100, 'Group name must be 100 characters or less.')
    if internal_group_name?(name)
      uuid = name.sub(ROLE_GROUP_PREFIX, '')
      assert(uuid.match?(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i), 'Group name has an invalid format.')
    end

    @name = name
  end

  def internal_group_name?(name)
    name.starts_with?(ROLE_GROUP_PREFIX)
  end

  def internal_group?
    internal_group_name?(name)
  end
end