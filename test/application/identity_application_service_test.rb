require './test/application/application_service_test'

class IdentityApplicationServiceTest < ApplicationServiceTest
  test 'activate tenant' do
    tenant = tenant_aggregate
    tenant.deactivate
    assert !tenant.active?

    ApplicationServiceRegistry.identity_application_service.activate_tenant(
      ActivateTenantCommand.new(tenant_id: tenant.tenant_id.id)
    )

    changed_tenant = DomainRegistry.tenant_repository.tenant_of_id(tenant.tenant_id)

    assert_not_nil changed_tenant
    assert_equal tenant.name, changed_tenant.name
    assert changed_tenant.active?
  end

  test 'add group to group' do
    parent_group = group_1_aggregate
    DomainRegistry.group_repository.add(parent_group)

    child_group = group_2_aggregate
    DomainRegistry.group_repository.add(child_group)

    assert_equal 0, parent_group.members.size

    ApplicationServiceRegistry.identity_application_service.add_group_to_group(
      AddGroupToGroupCommand.new(
        tenant_id: parent_group.tenant_id.id,
        parent_group_name: parent_group.name,
        child_group_name: child_group.name
      )
    )

    assert_equal 1, parent_group.members.size
  end

  test 'add user to group' do
    parent_group = group_1_aggregate
    DomainRegistry.group_repository.add(parent_group)

    child_group = group_2_aggregate
    DomainRegistry.group_repository.add(child_group)

    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    assert_equal 0, parent_group.members.size
    assert_equal 0, child_group.members.size

    parent_group.add_group(child_group, DomainRegistry.group_member_service)

    ApplicationServiceRegistry.identity_application_service.add_user_to_group(
      AddUserToGroupCommand.new(
        tenant_id: child_group.tenant_id.id,
        group_name: child_group.name,
        username: user.username
      )
    )

    assert_equal 1, parent_group.members.size
    assert_equal 1, child_group.members.size
    assert parent_group.member?(user, DomainRegistry.group_member_service)
    assert child_group.member?(user, DomainRegistry.group_member_service)
  end

  test 'authenticate user' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    user_descriptor = ApplicationServiceRegistry.identity_application_service.authenticate_user(
      AuthenticateUserCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        password: FIXTURE_PASSWORD
      )
    )

    assert_not_nil user_descriptor
    assert_equal user_descriptor.username, user.username
  end
end