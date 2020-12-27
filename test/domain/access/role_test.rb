require './test/domain/identity_access_test'

class RoleTest < IdentityAccessTest
  setup do
    @group_something_added_count = 0
    @group_something_removed_count = 0
    @group_something_assigned_count = 0
    @group_something_unassigned_count = 0
  end

  test 'provision role' do
    tenant = tenant_aggregate
    role = tenant.provision_role(name: 'Manager', description: 'A manager role.')
    DomainRegistry.role_repository.add(role)
    assert_equal 1, DomainRegistry.role_repository.all_roles(tenant.tenant_id).size
  end

  test 'role uniqueness' do
    tenant = tenant_aggregate
    role_1 = tenant.provision_role(name: 'Manager', description: 'A manager role.')
    DomainRegistry.role_repository.add(role_1)

    error = assert_raise StandardError do
      role_2 = tenant.provision_role(name: 'Manager', description: 'A manager role.')
      DomainRegistry.role_repository.add(role_2)
    end

    assert_equal 'Duplicate Key', error.message
  end

  test 'user is in role' do
    tenant = tenant_aggregate
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    manager_role = tenant.provision_role(name: 'Manager', description: 'A manager role.', supports_nesting: true)
    managers_group = tenant.provision_group('Managers', 'A group of managers.')
    DomainRegistry.group_repository.add(managers_group)

    manager_role.assign_group(managers_group, DomainRegistry.group_member_service)
    DomainRegistry.role_repository.add(manager_role)

    managers_group.add_user(user)

    assert managers_group.member?(user, DomainRegistry.group_member_service)
    assert manager_role.in_role?(user, DomainRegistry.group_member_service)
  end
end