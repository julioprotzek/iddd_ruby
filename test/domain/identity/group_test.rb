require './test/domain/identity_access_test'

class GroupTest < IdentityAccessTest
  setup do
    @group_group_added_count = 0
    @group_user_added_count = 0
  end

  test 'provision group' do
    tenant = tenant_aggregate
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)
    assert_equal 1, DomainRegistry.group_repository.all_groups(tenant.tenant_id).size
  end

  test 'add group' do
    group_group_added_count = 0
    DomainEventPublisher.instance.subscribe(GroupGroupAdded) do |a_domain_event|
      @group_group_added_count += 1
    end

    tenant = tenant_aggregate
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)
    group_b = tenant.provision_group('GroupB', 'A group named GroupB')
    DomainRegistry.group_repository.add(group_b)
    group_a.add_group(group_b, DomainRegistry.group_member_service)

    assert_equal 1, group_a.group_members.size
    assert_equal 0, group_b.group_members.size
    assert_equal 1, @group_group_added_count
  end

  test 'add user' do
    DomainEventPublisher.instance.subscribe(GroupUserAdded) do |a_domain_event|
      @group_user_added_count += 1
    end

    tenant = tenant_aggregate
    group_a = tenant.provision_group('Group A', 'A group named GroupA')
    user = user_aggregate
    DomainRegistry.user_repository.add(user)
    group_a.add_user(user)
    DomainRegistry.group_repository.add(group_a)

    assert_equal 1, group_a.group_members.size
    assert group_a.member?(user, DomainRegistry.group_member_service)
    assert_equal 1, @group_user_added_count
  end
end