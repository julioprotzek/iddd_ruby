require './test/domain/identity_access_test'

class AuthorizationServiceTest < IdentityAccessTest
  test 'user in role authorization' do
    tenant = tenant_aggregate
    user = user_aggregate
    DomainRegistry.user_repository.add(user)
    manager_role = tenant.provision_role(name: 'Manager', description: 'A manager role.', supports_nesting: true)

    manager_role.assign_user(user)

    DomainRegistry.role_repository.add(manager_role)

    is_authorized = DomainRegistry.authorization_service.user_in_role?(user, 'Manager')
    assert is_authorized

    is_authorized = DomainRegistry.authorization_service.user_in_role?(user, 'Director')
    assert !is_authorized
  end

  test 'username in role authorization' do
    tenant = tenant_aggregate
    user = user_aggregate
    DomainRegistry.user_repository.add(user)
    manager_role = tenant.provision_role(name: 'Manager', description: 'A manager role.', supports_nesting: true)

    manager_role.assign_user(user)

    DomainRegistry.role_repository.add(manager_role)

    is_authorized = DomainRegistry.authorization_service.username_in_role?(tenant.tenant_id, user.username, 'Manager')
    assert is_authorized

    is_authorized = DomainRegistry.authorization_service.username_in_role?(tenant.tenant_id, user.username, 'Director')
    assert !is_authorized
  end
end