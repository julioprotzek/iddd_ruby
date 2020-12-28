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
end