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
end