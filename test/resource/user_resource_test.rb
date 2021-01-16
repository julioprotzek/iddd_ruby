require './test/resource/abstract_resource_test'

class TenantResourceTest < AbstractResourceTest
  test 'authenticate user' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    get "/tenants/#{user.tenant_id.id}/users/#{user.username}/authenticate_with/#{FIXTURE_PASSWORD}"

    assert last_response.ok?, json_response[:error]
    assert_equal user.tenant_id.id, json_response[:tenant_id][:id]
    assert_equal user.username, json_response[:username]
    assert_equal user.person.email_address.address, json_response[:email_address]
  end

  test 'try to authenticate user with wrong password' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    get "/tenants/#{user.tenant_id.id}/users/#{user.username}/authenticate_with/#{SecureRandom.uuid}"

    assert last_response.unauthorized?
    assert_equal 'User not authenticated.', json_response[:error]
  end

  test 'find user' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    get "/tenants/#{user.tenant_id.id}/users/#{user.username}"

    assert last_response.ok?
    assert_equal user.tenant_id.id, json_response[:tenant_id]
    assert_equal user.username, json_response[:username]
    assert json_response[:enabled]
  end

  test 'try to find non existent user' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    get "/tenants/#{user.tenant_id.id}/users/NON-EXISTENT-USERNAME"

    assert last_response.not_found?
    assert_equal 'User not found.', json_response[:error]
  end

  test 'find user in role' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)
    role = role_aggregate
    role.assign_user(user)
    DomainRegistry.role_repository.create(role)

    get "/tenants/#{user.tenant_id.id}/users/#{user.username}/in_role/#{url_encode(role.name)}"

    assert last_response.ok?
    assert_equal user.tenant_id.id, json_response[:tenant_id]
    assert_equal user.username, json_response[:username]
    assert_equal role.name, json_response[:role]
  end
end