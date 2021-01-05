require './test/domain/identity_access_test'

class TenantTest < IdentityAccessTest
  test 'provision tenant' do
    provision_handled = false
    DomainEventPublisher.subscribe(TenantProvisioned) do |domain_event|
      provision_handled = true
    end

    registration_handled = false
    DomainEventPublisher.subscribe(TenantAdministratorRegistered) do |domain_event|
      registration_handled = true
    end

    tenant = DomainRegistry
      .tenant_provision_service
      .provision_tenant(
        name: FIXTURE_TENANT_NAME,
        description: FIXTURE_TENANT_DESCRIPTION,
        administrator_name: FullName.new(
          first_name: 'John',
          last_name: 'Doe'
        ),
        email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
        postal_address: PostalAddress.new(
          street_address: '123 Pearl Street',
          city: 'Boulder',
          state_province: 'CO',
          postal_code: '80301',
          country_code: 'US'
        ),
        primary_phone: PhoneNumber.new('303-555-1210'),
        secondary_phone: PhoneNumber.new('777-123-1011')
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

    tenant
      .offer_registration_invitation('Open-Ended')
      .open_ended

    assert_not_nil tenant.redefine_registration_invitation_as('Open-Ended')
  end

  test 'available close ended invitation' do
    tenant = tenant_aggregate

    tenant
      .offer_registration_invitation('Today-and-Tomorrow')
      .starting_at(Date.today)
      .ending_at(Date.tomorrow)

      assert tenant.registration_available_through?('Today-and-Tomorrow')
  end

  test 'unavailable close ended invitation' do
    tenant = tenant_aggregate

    tenant
      .offer_registration_invitation('Tomorrow-and-Day-After-Tomorrow')
      .starting_at(Date.tomorrow)
      .ending_at(Date.tomorrow + 1.day)

      assert !tenant.registration_available_through?('Tomorrow-and-Day-After-Tomorrow')
  end

  test 'available invitation descriptor' do
    tenant = tenant_aggregate

    tenant
      .offer_registration_invitation('Open-Ended')
      .open_ended

    tenant
      .offer_registration_invitation('Today-and-Tomorrow')
      .starting_at(Date.today)
      .ending_at(Date.tomorrow)

    assert_equal 2, tenant.all_available_registration_invitations.size
  end

  test 'unavailable invitation descriptor' do
    tenant = tenant_aggregate

    tenant
      .offer_registration_invitation('Tomorrow-and-Day-After-Tomorrow')
      .starting_at(Date.tomorrow)
      .ending_at(Date.tomorrow + 1.day)

    assert_equal 1, tenant.all_unavailable_registration_invitations.size
  end

  test 'register user' do
    tenant = tenant_aggregate

    registration_invitation = registration_invitation_entity_for(tenant)

    user = tenant.register_user(
      invitation_identifier: registration_invitation.invitation_id,
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity_for(tenant)
    )

    assert_not_nil user

    DomainRegistry.user_repository.add(user)

    assert_not_nil user.enablement
    assert_not_nil user.person
    assert_not_nil user.user_descriptor
  end
end