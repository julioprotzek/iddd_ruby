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
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)
    assert_equal 1, DomainRegistry.group_repository.all_groups(tenant.tenant_id).size
  end

  test 'add group' do
    group_group_added_count = 0
    DomainEventPublisher.subscribe(GroupGroupAdded){ @group_group_added_count += 1 }

    tenant = tenant_aggregate
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)
    group_b = tenant.provision_group('GroupB', 'A group named GroupB')
    DomainRegistry.group_repository.add(group_b)
    group_a.add_group(group_b, DomainRegistry.group_member_service)

    assert_equal 1, group_a.members.size
    assert_equal 0, group_b.members.size
    assert_equal 1, @group_group_added_count
  end

  test 'add user' do
    DomainEventPublisher.subscribe(GroupUserAdded){ @group_user_added_count += 1 }

    tenant = tenant_aggregate
    group_a = tenant.provision_group('Group A', 'A group named GroupA')
    user = user_aggregate
    DomainRegistry.user_repository.add(user)
    group_a.add_user(user)
    DomainRegistry.group_repository.add(group_a)

    assert_equal 1, group_a.members.size
    assert group_a.member?(user, DomainRegistry.group_member_service)
    assert_equal 1, @group_user_added_count
  end

  test 'remove group' do
    DomainEventPublisher.subscribe(GroupGroupRemoved){ @group_group_removed_count += 1 }

    tenant = tenant_aggregate

    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)

    group_b = tenant.provision_group('GroupB', 'A group named GroupB')
    DomainRegistry.group_repository.add(group_b)

    group_a.add_group(group_b, DomainRegistry.group_member_service)

    assert_equal 1, group_a.members.size
    group_a.remove_group(group_b)
    assert_equal 0, group_a.members.size
    assert_equal 1, @group_group_removed_count
  end

  test 'remove user' do
    DomainEventPublisher.subscribe(GroupUserRemoved){ @group_user_removed_count += 1 }

    tenant = tenant_aggregate
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)

    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    group_a.add_user(user)

    assert_equal 1, group_a.members.size
    group_a.remove_user(user)
    assert_equal 0, group_a.members.size
    assert_equal 1, @group_user_removed_count
  end

  test 'remove group referenced user' do
    tenant = tenant_aggregate
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
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
    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)
    not_nil_group = DomainRegistry.group_repository.group_named(tenant.tenant_id, 'GroupA')
    assert_not_nil not_nil_group

    DomainRegistry.group_repository.remove(group_a)
    nil_group = DomainRegistry.group_repository.group_named(tenant.tenant_id, 'GroupA')

    assert_nil nil_group
  end

  test 'user is member of nested group' do
    DomainEventPublisher.subscribe(GroupGroupAdded){ @group_group_added_count += 1 }

    tenant = tenant_aggregate

    group_a = tenant.provision_group('GroupA', 'A group named GroupA')
    DomainRegistry.group_repository.add(group_a)

    group_b = tenant.provision_group('GroupB', 'A group named GroupB')
    DomainRegistry.group_repository.add(group_b)

    group_a.add_group(group_b, DomainRegistry.group_member_service)

    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    group_b.add_user(user)

    assert group_b.member?(user, DomainRegistry.group_member_service)
    assert group_a.member?(user, DomainRegistry.group_member_service)
    assert_equal 1, @group_group_added_count
  end
end