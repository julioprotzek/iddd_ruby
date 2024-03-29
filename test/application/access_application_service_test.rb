require './test/application/application_service_test'

class AccessApplicationServiceTest < ApplicationServiceTest
  test 'assign user to role' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    role = role_aggregate
    DomainRegistry.role_repository.create(role)

    assert !role.in_role?(user, DomainRegistry.group_member_service)

    ApplicationServiceRegistry.access_application_service.assign_user_to_role(
      AssignUserToRoleCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        role_name: role.name
      )
    )

    role = DomainRegistry.role_repository.reload(role)

    assert role.in_role?(user, DomainRegistry.group_member_service)
  end

  test 'user is in role' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    role = role_aggregate
    DomainRegistry.role_repository.create(role)

    assert !ApplicationServiceRegistry.access_application_service.user_in_role?(
      tenant_id: user.tenant_id.id,
      username: user.username,
      role_name: role.name
    )

    ApplicationServiceRegistry.access_application_service.assign_user_to_role(
      AssignUserToRoleCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        role_name: role.name
      )
    )

    assert ApplicationServiceRegistry.access_application_service.user_in_role?(
      tenant_id: user.tenant_id.id,
      username: user.username,
      role_name: role.name
    )
  end

  test 'user in role' do
    user = user_aggregate
    DomainRegistry.user_repository.create(user)

    role = role_aggregate
    DomainRegistry.role_repository.create(role)


    user_not_in_role = ApplicationServiceRegistry.access_application_service.user_in_role(
      tenant_id: user.tenant_id.id,
      username: user.username,
      role_name: role.name
    )

    assert_nil user_not_in_role

    ApplicationServiceRegistry.access_application_service.assign_user_to_role(
      AssignUserToRoleCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        role_name: role.name
      )
    )

    user_in_role = ApplicationServiceRegistry.access_application_service.user_in_role(
      tenant_id: user.tenant_id.id,
      username: user.username,
      role_name: role.name
    )

    assert_not_nil user_in_role
  end
end