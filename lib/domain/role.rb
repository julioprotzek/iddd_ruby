class Role
  include Concerns::Assertion

  attr_reader :tenant_id, :name, :description, :supports_nesting

  def initialize(tenant_id, name, description, supports_nesting)
    assert_presence(tenant_id, 'The tenant id is required')
    @tenant_id = tenant_id

    assert_presence(name, 'Role name is required')
    @name = name

    assert_presence(description, 'Role description is required')
    assert_length(description, 1, 250, 'Role description must have 250 characters or less.')
    @description = description

    @supports_nesting = supports_nesting

    create_internal_group
  end

  def assign_user(an_user)
    assert_presence(tenant_id, 'User must be provided.')
    assert_equal(tenant_id, an_user.tenant_id, 'Wrong tenant for this user.')

    @group.add_user(an_user)

    # NOTE: Consider what a consuming Bounded Context would
    # need to do if this event was not enriched with the
    # last three user person properties. (Hint: A lot.)
    DomainEventPublisher.instance.publish(UserAssignedToRole.new(
      tenant_id,
      name,
      an_user.username,
      an_user.person.name.first_name,
      an_user.person.name.last_name,
      an_user.person.email_address.address
    ))
  end

  def create_internal_group
    group_name = Group::ROLE_GROUP_PREFIX + SecureRandom.uuid.upcase

    @group = Group.new(
      tenant_id,
      group_name,
      "Role backing group for: #{name}"
    )
  end
end