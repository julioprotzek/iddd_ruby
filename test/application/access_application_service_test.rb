require './test/application/application_service_test'

class AccessApplicationServiceTest < ApplicationServiceTest
  test 'assign user to role' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    role = role_aggregate
    DomainRegistry.role_repository.add(role)

    assert !role.in_role?(user, DomainRegistry.group_member_service)

    ApplicationServiceRegistry.access_application_service.assign_user_to_role(
      AssignUserToRoleCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        role_name: role.name
      )
    )

    assert role.in_role?(user, DomainRegistry.group_member_service)
  end

  test 'user is in role' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    role = role_aggregate
    DomainRegistry.role_repository.add(role)

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
end