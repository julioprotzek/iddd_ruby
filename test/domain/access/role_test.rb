require './test/domain/identity_access_test'

class RoleTest < IdentityAccessTest
  setup do
    @group_something_added_count = 0
    @group_something_removed_count = 0
    @role_something_assigned_count = 0
    @role_something_unassigned_count = 0
  end

  test 'provision role' do
    tenant = tenant_aggregate
    role = tenant.provision_role(name: 'Manager', description: 'A manager role.')
    DomainRegistry.role_repository.create(role)
    assert_equal 1, DomainRegistry.role_repository.all_roles(tenant.tenant_id).size
  end

  test 'role uniqueness' do
    tenant = tenant_aggregate
    role_1 = tenant.provision_role(name: 'Manager', description: 'A manager role.')
    DomainRegistry.role_repository.create(role_1)

    error = assert_raise StandardError do
      role_2 = tenant.provision_role(name: 'Manager', description: 'A manager role.')
      DomainRegistry.role_repository.create(role_2)
    end

    assert_equal 'Validation failed: Name has already been taken', error.message
  end

  test 'user is in role' do
    tenant = tenant_aggregate
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    manager_role = tenant.provision_role(name: 'Manager', description: 'A manager role.', supports_nesting: true)
    managers_group = tenant.provision_group(name: 'Managers', description: 'A group of managers.')
    DomainRegistry.group_repository.add(managers_group)

    manager_role.assign_group(managers_group, DomainRegistry.group_member_service)
    DomainRegistry.role_repository.create(manager_role)

    managers_group.add_user(user)
    DomainRegistry.group_repository.add(managers_group)

    assert managers_group.member?(user, DomainRegistry.group_member_service)
    assert manager_role.in_role?(user, DomainRegistry.group_member_service)
  end

  test 'user is not in role' do
    tenant = tenant_aggregate
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    manager_role = tenant.provision_role(name: 'Manager', description: 'A manager role.', supports_nesting: true)
    managers_group = tenant.provision_group(name: 'Managers', description: 'A group of managers.')
    DomainRegistry.group_repository.add(managers_group)

    manager_role.assign_group(managers_group, DomainRegistry.group_member_service)
    DomainRegistry.role_repository.create(manager_role)
    accountant_role = Role.new(user.tenant_id, 'Accountant', 'An accountant role.')
    DomainRegistry.role_repository.create(accountant_role)

    assert !manager_role.in_role?(user, DomainRegistry.group_member_service)
    assert !accountant_role.in_role?(user, DomainRegistry.group_member_service)
  end

  test 'no role internal groups in find group by name' do
    tenant = tenant_aggregate
    role_a = tenant.provision_role(name: 'RoleA', description: 'A role of A')
    DomainRegistry.role_repository.create(role_a)

    error = assert_raises do
      DomainRegistry.group_repository.group_named(tenant.tenant_id, role_a.group.name)
    end

    assert_equal 'May not find internal groups.', error.message
  end

  test 'internal group added events are not published' do
    DomainEventPublisher.subscribe(GroupAssignedToRole){ @role_something_assigned_count += 1 }
    DomainEventPublisher.subscribe(GroupGroupAdded){ @group_something_added_count += 1 }
    DomainEventPublisher.subscribe(UserAssignedToRole){ @role_something_assigned_count += 1 }
    DomainEventPublisher.subscribe(GroupUserAdded){ @group_something_added_count += 1 }

    tenant = tenant_aggregate
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    manager_role = tenant.provision_role(name: 'Manager', description: 'A manager role.', supports_nesting: true)
    managers_group = tenant.provision_group(name: 'Managers', description: 'A group of managers.')
    DomainRegistry.group_repository.add(managers_group)

    manager_role.assign_group(managers_group, DomainRegistry.group_member_service)
    manager_role.assign_user(user)
    DomainRegistry.role_repository.create(manager_role)
    managers_group.add_user(user) # legal add

    assert_equal 2, @role_something_assigned_count
    assert_equal 1, @group_something_added_count
  end

  test 'internal group removed events are not published' do
    DomainEventPublisher.subscribe(GroupUnassignedFromRole){ @role_something_unassigned_count += 1 }
    DomainEventPublisher.subscribe(GroupGroupRemoved){ @group_something_removed_count += 1 }
    DomainEventPublisher.subscribe(UserUnassignedFromRole){ @role_something_unassigned_count += 1 }
    DomainEventPublisher.subscribe(GroupUserRemoved){ @group_something_removed_count += 1 }

    tenant = tenant_aggregate
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    manager_role = tenant.provision_role(name: 'Manager', description: 'A manager role.', supports_nesting: true)
    managers_group = tenant.provision_group(name: 'Managers', description: 'A group of managers.')
    DomainRegistry.group_repository.add(managers_group)

    manager_role.assign_user(user)
    manager_role.assign_group(managers_group, DomainRegistry.group_member_service)
    DomainRegistry.role_repository.create(manager_role)

    manager_role.unassign_user(user)
    manager_role.unassign_group(managers_group)

    assert_equal 2, @role_something_unassigned_count
    assert_equal 0, @group_something_removed_count
  end
end