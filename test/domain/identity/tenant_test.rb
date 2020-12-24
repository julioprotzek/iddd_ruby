require './test/domain/identity_access_test'

class TenantTest < IdentityAccessTest
  test 'provision tenant' do
    provision_handled = false
    DomainEventPublisher.instance.subscribe(TenantProvisioned) do |a_domain_event|
      provision_handled = true
    end

    registration_handled = false
    DomainEventPublisher.instance.subscribe(TenantAdministratorRegistered) do |a_domain_event|
      registration_handled = true
    end

    tenant = DomainRegistry
      .tenant_provision_service
      .provision_tenant(
        name: FIXTURE_TENANT_NAME,
        description: FIXTURE_TENANT_DESCRIPTION,
        administrator_name: FullName.new('John', 'Doe'),
        email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
        postal_address: PostalAddress.new(
          '123 Pearl Street',
          'Boulder',
          'CO',
          '80301',
          'US'
        ),
        primary_telephone: Telephone.new('303-555-1210'),
        secondary_telephone: Telephone.new('777-123-1011')
      )

    assert provision_handled
    assert registration_handled

    assert tenant.tenant_id.present?
    assert tenant.tenant_id.id.present?
    assert_equal 36, tenant.tenant_id.id.size
    assert_equal FIXTURE_TENANT_NAME, tenant.name
    assert_equal FIXTURE_TENANT_DESCRIPTION, tenant.description
  end

  test 'create open ended invitation' do
    tenant = tenant_aggregate
    tenant.offer_registration_invitation('Open-Ended').open_ended
    assert_not_nil tenant.redefine_registration_invitation_as('Open-Ended')
  end

  test 'close ended invitation availability' do
    tenant = tenant_aggregate
    tenant.offer_registration_invitation('Today-and-Tomorrow').starting_at(Date.today).ending_at(Date.tomorrow)
    assert tenant.registration_available_through?('Today-and-Tomorrow')
  end
end