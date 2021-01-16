require './test/domain/identity_access_test'

class GroupTest < IdentityAccessTest
  setup do
    @group_group_added_count = 0
    @group_user_added_count = 0
    @group_group_removed_count = 0
    @group_user_removed_count = 0
  end

  test 'provision group' do
    tenant = tenant_aggregate
    group_a = tenant.provision_group(name: 'GroupA', description: 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)
    assert_equal 1, DomainRegistry.group_repository.all_groups(tenant.tenant_id).size
  end

  test 'add group' do
    DomainEventPublisher.subscribe(GroupGroupAdded){ @group_group_added_count += 1 }

    tenant = tenant_aggregate
    group_a = tenant.provision_group(name: 'GroupA', description: 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)
    group_b = tenant.provision_group(name: 'GroupB', description: 'A group named GroupB')
    DomainRegistry.group_repository.create(group_b)
    group_a.add_group(group_b, DomainRegistry.group_member_service)

    assert_equal 1, group_a.members.size
    assert_equal 0, group_b.members.size
    assert_equal 1, @group_group_added_count
  end

  test 'add user' do
    DomainEventPublisher.subscribe(GroupUserAdded){ @group_user_added_count += 1 }

    tenant = tenant_aggregate
    group_a = tenant.provision_group(name: 'Group A', description: 'A group named GroupA')
    user = user_aggregate
    DomainRegistry.user_repository.create(user)
    group_a.add_user(user)
    DomainRegistry.group_repository.create(group_a)

    assert_equal 1, group_a.members.size
    assert group_a.member?(user, DomainRegistry.group_member_service)
    assert_equal 1, @group_user_added_count
  end

  test 'remove group' do
    DomainEventPublisher.subscribe(GroupGroupRemoved){ @group_group_removed_count += 1 }

    tenant = tenant_aggregate

    group_a = tenant.provision_group(name: 'GroupA', description: 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)

    group_b = tenant.provision_group(name: 'GroupB', description: 'A group named GroupB')
    DomainRegistry.group_repository.create(group_b)

    group_a.add_group(group_b, DomainRegistry.group_member_service)

    assert_equal 1, group_a.members.size
    group_a.remove_group(group_b)
    assert_equal 0, group_a.members.size
    assert_equal 1, @group_group_removed_count
  end

  test 'remove user' do
    DomainEventPublisher.subscribe(GroupUserRemoved){ @group_user_removed_count += 1 }

    tenant = tenant_aggregate
    group_a = tenant.provision_group(name: 'GroupA', description: 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)

    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    group_a.add_user(user)

    assert_equal 1, group_a.members.size
    group_a.remove_user(user)
    assert_equal 0, group_a.members.size
    assert_equal 1, @group_user_removed_count
  end

  test 'user is member of nested group' do
    DomainEventPublisher.subscribe(GroupGroupAdded){ @group_group_added_count += 1 }

    tenant = tenant_aggregate

    group_a = tenant.provision_group(name: 'GroupA', description: 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)

    group_b = tenant.provision_group(name: 'GroupB', description: 'A group named GroupB')
    DomainRegistry.group_repository.create(group_b)

    group_a.add_group(group_b, DomainRegistry.group_member_service)

    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    group_b.add_user(user)
    DomainRegistry.group_repository.update(group_b)

    assert group_b.member?(user, DomainRegistry.group_member_service)
    assert group_a.member?(user, DomainRegistry.group_member_service)
    assert_equal 1, @group_group_added_count
  end

  test 'user is not member' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    # test alternate creation via constructor
    group_a = Group.new(user.tenant_id, 'GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)
    group_b = Group.new(user.tenant_id, 'GroupB', 'A group named GroupB')
    DomainRegistry.group_repository.create(group_b)

    group_a.add_group(group_b, DomainRegistry.group_member_service)

    assert !group_b.member?(user, DomainRegistry.group_member_service)
    assert !group_a.member?(user, DomainRegistry.group_member_service)
  end

  test 'no recursive groupings' do
    DomainEventPublisher.subscribe(GroupGroupAdded){ @group_group_added_count += 1 }

    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    # test alternate creation via constructor
    group_a = Group.new(user.tenant_id, 'GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)
    group_b = Group.new(user.tenant_id, 'GroupB', 'A group named GroupB')
    DomainRegistry.group_repository.create(group_b)
    group_c = Group.new(user.tenant_id, 'GroupC', 'A group named GroupC')
    DomainRegistry.group_repository.create(group_c)

    group_a.add_group(group_b, DomainRegistry.group_member_service)
    DomainRegistry.group_repository.update(group_a)

    group_b.add_group(group_c, DomainRegistry.group_member_service)
    DomainRegistry.group_repository.update(group_b)

    error = assert_raise StandardError do
      group_c.add_group(group_a, DomainRegistry.group_member_service)
    end

    assert_equal 'Group recursion.', error.message
    assert_equal 2, @group_group_added_count
  end

  test 'no role internal groups in find_all_groups' do
    tenant = tenant_aggregate
    group_a = tenant.provision_group(name: 'GroupA', description: 'A group named GroupA')
    DomainRegistry.group_repository.create(group_a)

    role_a = tenant.provision_role(name: 'RoleA', description: 'A role of A.')
    DomainRegistry.role_repository.create(role_a)

    role_b = tenant.provision_role(name: 'RoleB', description: 'A role of B.')
    DomainRegistry.role_repository.create(role_b)

    role_c = tenant.provision_role(name: 'RoleC', description: 'A role of C.')
    DomainRegistry.role_repository.create(role_c)

    groups = DomainRegistry.group_repository.all_groups(tenant.tenant_id)

    assert_equal 1, groups.size
  end
end