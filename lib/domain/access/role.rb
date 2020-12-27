class Role
  include Assertion

  attr_reader :tenant_id, :name, :description, :group

  def initialize(tenant_id, name, description, supports_nesting = false)
    self.tenant_id= tenant_id
    self.name= name
    self.description= description

    @supports_nesting = supports_nesting

    create_internal_group
  end

  def assign_group(group, group_member_service)
    assert(supports_nesting?, 'This role does not support group nesting.')
    assert_presence(group, 'Group must be provided.')
    assert_equal(tenant_id, group.tenant_id, 'Wrong tenant for this group.')

    self.group.add_group(group, group_member_service)

    DomainEventPublisher.publish(GroupAssignedToRole.new(tenant_id, name, group.name))
  end

  def assign_user(user)
    assert_presence(tenant_id, 'User must be provided.')
    assert_equal(tenant_id, user.tenant_id, 'Wrong tenant for this user.')

    self.group.add_user(user)

    # NOTE: Consider what a consuming Bounded Context would
    # need to do if this event was not enriched with the
    # last three user person properties. (Hint: A lot.)
    DomainEventPublisher.publish(UserAssignedToRole.new(
      tenant_id,
      name,
      user.username,
      user.person.name.first_name,
      user.person.name.last_name,
      user.person.email_address.address
    ))
  end

  def in_role?(user, group_member_service)
    self.group.member?(user, group_member_service)
  end

  def supports_nesting?
    @supports_nesting == true
  end

  private

  def create_internal_group
    group_name = Group::ROLE_GROUP_PREFIX + SecureRandom.uuid.upcase

    @group = Group.new(
      tenant_id,
      group_name,
      "Role backing group for: #{name}"
    )
  end

  def tenant_id=(tenant_id)
    assert_presence(tenant_id, 'The tenant id is required')
    @tenant_id = tenant_id
  end

  def name=(name)
    assert_presence(name, 'Role name is required')
    @name = name
  end

  def description=(description)
    assert_presence(description, 'Role description is required')
    assert_length(description, 1, 250, 'Role description must have 250 characters or less.')
    @description = description
  end
end