class Group
  include Assertion

  ROLE_GROUP_PREFIX = 'ROLE-INTERNAL-GROUP: '

  attr_reader :tenant_id, :name, :description, :members

  def initialize(a_tenant_id, a_name, a_description)
    self.tenant_id = a_tenant_id
    self.name = a_name
    self.description = a_description
    @members = Set.new
  end

  def add_group(a_group, a_group_member_service)
    assert_presence(a_group, 'Group must be provided.')
    assert_equal(tenant_id, a_group.tenant_id, 'Wrong tenant for this group.')
    assert(!a_group_member_service.member_group?(a_group, self), 'Group recurrsion.')

    if members.add?(a_group) && !internal_group?
      DomainEventPublisher.publish(
        GroupGroupAdded.new(
          tenant_id,
          name,
          a_group.name
        )
      )
    end
  end

  def add_user(an_user)
    assert_presence(an_user, 'User must be provided.')
    assert_equal(tenant_id, an_user.tenant_id, 'Wrong tenant for this group.')
    assert(an_user.enabled?, 'User is not enabled.')

    if members.add?(an_user) && !internal_group?
      DomainEventPublisher.publish(
        GroupUserAdded.new(
          tenant_id,
          name,
          an_user.username
        )
      )
    end
  end

  def member?(an_user, a_group_member_service)
    assert_presence(an_user, 'User must be provided.')
    assert_equal(tenant_id, an_user.tenant_id, 'Wrong tenant for this group.')
    assert(an_user.enabled?, 'User is not enabled.')

    if an_user.in?(members)
      return a_group_member_service.confirm_user(self, an_user)
    else
      return a_group_member_service.in_nested_group?(self, an_user)
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

  private

  def tenant_id=(a_tenant_id)
    assert_presence(a_tenant_id, 'The Tenant Id must be provided.')
    @tenant_id = a_tenant_id
  end

  def description=(a_description)
    assert_presence(a_description, 'Group description is required.')
    assert_length(a_description, 1, 250, 'Group description must be 250 characters or less.')

    @description = a_description
  end

  def name=(a_name)
    assert_presence(a_name, 'Group name is required.')
    assert_length(a_name, 1, 100, 'Group name must be 100 characters or less.')
    if internal_group_name?(a_name)
      uuid = a_name.sub(ROLE_GROUP_PREFIX, '')
      assert(uuid.match?(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i), 'Group name has an invalid format.')
    end

    @name = a_name
  end

  def internal_group_name?(a_name)
    a_name.starts_with?(ROLE_GROUP_PREFIX)
  end

  def internal_group?
    internal_group_name?(name)
  end
end