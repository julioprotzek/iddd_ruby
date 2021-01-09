module TenantRepositorySharedTests
  FIXTURE_TENANT_DESCRIPTION = 'This is a test tenant'
  FIXTURE_TENANT_NAME = 'Test tenant'

  def it_behaves_like_a_tenant_repository
    test 'save tenant with invitations' do
      tenant_id = DomainRegistry.tenant_repository.next_identity

      tenant = Tenant.new(
        tenant_id: tenant_id,
        name: FIXTURE_TENANT_NAME,
        description: FIXTURE_TENANT_DESCRIPTION,
        active: true
      )

      registration_invitation = tenant
        .offer_registration_invitation("Today-and-Tomorrow #{SecureRandom.rand}")
        .starting_at(Date.today)
        .ending_at(Date.tomorrow)

      DomainRegistry.tenant_repository.create(tenant)

      reloaed_tenant = DomainRegistry.tenant_repository.tenant_of_id(tenant_id)

      assert_equal tenant_id, reloaed_tenant.tenant_id
      assert_equal FIXTURE_TENANT_NAME, reloaed_tenant.name
      assert_equal 1, reloaed_tenant.registration_invitations.size
      reloaded_invitation = reloaed_tenant.registration_invitations.first
      assert_equal registration_invitation, reloaded_invitation
    end
  end
end