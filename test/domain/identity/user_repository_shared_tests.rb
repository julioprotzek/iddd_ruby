module UserRepositorySharedTests
  def it_behaves_like_a_user_repository
    test 'add user and find by username' do
      user = user_aggregate

      DomainRegistry.user_repository.add(user)

      assert_not_nil DomainRegistry.user_repository.find_by(tenant_id: user.tenant_id, username: user.username)
    end

    test 'remove user' do
      user = user_aggregate

      DomainRegistry.user_repository.add(user)

      assert_not_nil DomainRegistry.user_repository.find_by(tenant_id: user.tenant_id, username: user.username)

      DomainRegistry.user_repository.remove(user)

      assert_nil DomainRegistry.user_repository.find_by(tenant_id: user.tenant_id, username: user.username)
    end

    test 'find similar named users' do
      user = user_aggregate
      DomainRegistry.user_repository.add(user)

      user2 = user_aggregate_2
      DomainRegistry.user_repository.add(user2)

      name = user.person.name

      users = DomainRegistry.user_repository.all_similar_named_users(tenant_id: user.tenant_id, first_name_prefix: '', last_name_prefix: name.last_name[0, 2])

      assert_equal 2, users.size
    end
  end
end