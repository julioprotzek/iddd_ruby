module GroupRepositorySharedTests
  def it_behaves_like_a_group_repository
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

    test 'group A < group B < group C' do
      tenant = tenant_aggregate
      group_a = tenant.provision_group(name: 'Group A', description: 'A group member A.')
      DomainRegistry.group_repository.add(group_a)

      group_b = tenant.provision_group(name: 'Group B', description: 'A group member B.')
      DomainRegistry.group_repository.add(group_b)

      group_c = tenant.provision_group(name: 'Group C', description: 'A group member C.')
      DomainRegistry.group_repository.add(group_c)


      group_a.add_group(group_b, DomainRegistry.group_member_service)
      DomainRegistry.group_repository.add(group_a)

      group_b.add_group(group_c, DomainRegistry.group_member_service)
      DomainRegistry.group_repository.add(group_b)

      user = user_aggregate
      DomainRegistry.user_repository.add(user)
      group_c.add_user(user)
      DomainRegistry.group_repository.add(group_c)

      group_a = DomainRegistry.group_repository.reload(group_a)
      group_b = DomainRegistry.group_repository.reload(group_b)
      group_c = DomainRegistry.group_repository.reload(group_c)

      assert_equal 1, group_a.members.size
      assert group_b.as_member.in?(group_a.members)

      assert_equal 1, group_b.members.size
      assert group_c.as_member.in?(group_b.members)

      assert_equal 1, group_c.members.size
      assert user.as_member.in?(group_c.members)
    end
  end
end