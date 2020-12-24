require './test/domain/identity_access_test'

class AuthenticationServiceTest < IdentityAccessTest
  setup do
    DomainRegistry.user_repository.clean
  end

  test 'authentication success' do
    user = user_aggregate

    DomainRegistry.user_repository.add(user)

    user_descriptor = DomainRegistry
      .authentication_service
      .authenticate(user.tenant_id, user.username, FIXTURE_PASSWORD)

    assert_not_nil user_descriptor
    assert !user_descriptor.null_descriptor?
    assert_equal user.tenant_id, user_descriptor.tenant_id
    assert_equal user.username, user_descriptor.username
    assert_equal user.person.email_address.address, user_descriptor.email_address
  end
end