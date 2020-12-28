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
end