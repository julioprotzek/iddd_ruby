require './test/domain/identity_access_test'

class GroupTest < IdentityAccessTest
  test 'provision group' do
    tenant = tenant_aggregate
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)
    assert_equal 1, DomainRegistry.group_repository.all_groups(tenant.tenant_id).size
  end
end