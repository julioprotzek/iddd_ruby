require './test/domain/identity_access_test'

class ActiveRecordGroupRepositoryTest < IdentityAccessTest
  setup do
    DomainRegistry.stubs(:group_repository).returns(ActiveRecord::GroupRepository.new)
    DomainRegistry.group_repository.clean
  end

  test 'remove group referenced user' do
    tenant = tenant_aggregate
    group_a = tenant.provision_group(name: 'GroupA', description: 'A group member A.')
    user = user_aggregate
    DomainRegistry.user_repository.add(user)
    group_a.add_user(user)
    DomainRegistry.group_repository.add(group_a)

    assert_equal 1, group_a.members.size
    assert group_a.member?(user, DomainRegistry.group_member_service)
    DomainRegistry.user_repository.remove(user)

    re_grouped = DomainRegistry.group_repository.group_named(tenant.tenant_id, 'GroupA')
    assert_equal 'GroupA', re_grouped.name
    assert_equal 1, re_grouped.members.size
    assert !re_grouped.member?(user, DomainRegistry.group_member_service)
  end

  test 'remove repository group' do
    tenant = tenant_aggregate
    group_a = tenant.provision_group(name: 'GroupA', description: 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)
    not_nil_group = DomainRegistry.group_repository.group_named(tenant.tenant_id, 'GroupA')
    assert_not_nil not_nil_group

    DomainRegistry.group_repository.remove(group_a)
    nil_group = DomainRegistry.group_repository.group_named(tenant.tenant_id, 'GroupA')

    assert_nil nil_group
  end
end