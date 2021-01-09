require './test/domain/identity_access_test'

class AuthenticationServiceTest < IdentityAccessTest
  test 'authentication success' do
    user = user_aggregate

    DomainRegistry.user_repository.create(user)

    user_descriptor = DomainRegistry
      .authentication_service
      .authenticate(user.tenant_id, user.username, FIXTURE_PASSWORD)

    assert_not_nil user_descriptor
    assert !user_descriptor.null_descriptor?
    assert_equal user.tenant_id, user_descriptor.tenant_id
    assert_equal user.username, user_descriptor.username
    assert_equal user.person.email_address.address, user_descriptor.email_address
  end

  test 'authentication tenant failure' do
    user = user_aggregate

    DomainRegistry.user_repository.create(user)

    user_descriptor = DomainRegistry
      .authentication_service
      .authenticate(DomainRegistry.tenant_repository.next_identity, user.username, FIXTURE_PASSWORD)

    assert_not_nil user_descriptor
    assert user_descriptor.null_descriptor?
  end

  test 'authentication username failure' do
    user = user_aggregate

    DomainRegistry.user_repository.create(user)

    user_descriptor = DomainRegistry
      .authentication_service
      .authenticate(user.tenant_id, FIXTURE_USERNAME_2, FIXTURE_PASSWORD)

    assert_not_nil user_descriptor
    assert user_descriptor.null_descriptor?
  end

  test 'authentication password failure' do
    user = user_aggregate

    DomainRegistry.user_repository.create(user)

    user_descriptor = DomainRegistry
      .authentication_service
      .authenticate(user.tenant_id, user.username, FIXTURE_PASSWORD + '-')

    assert_not_nil user_descriptor
    assert user_descriptor.null_descriptor?
  end
end