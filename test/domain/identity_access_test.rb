require './test/test_helper'

class IdentityAccessTest < ActiveSupport::TestCase
  FIXTURE_PASSWORD = 'SecretPassword@123'
  FIXTURE_TENANT_DESCRIPTION = 'This is a test tenant'
  FIXTURE_TENANT_NAME = 'Test tenant'
  FIXTURE_USER_EMAIL_ADDRESS = 'jdoe@example.com'
  FIXTURE_USER_EMAIL_ADDRESS_2 = 'zdoe@example.com'
  FIXTURE_USERNAME = 'jdoe'
  FIXTURE_USERNAME_2 = 'zdoe'

  setup do
    DomainEventPublisher.instance.reset
  end

  def contact_information
    ContactInformation.new(
      EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('303-555-1210'),
      Telephone.new('777-123-1011')
    )
  end

  def contact_information_2
    ContactInformation.new(
      EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS_2),
      PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('303-555-1210'),
      Telephone.new('777-123-1011')
    )
  end

  def person_entity_for(a_tenant)
    Person.new(
      a_tenant.tenant_id,
      FullName.new('Zoe', 'Doe'),
      contact_information
    )
  end

  def person_entity_2_for(a_tenant)
    Person.new(
      a_tenant.tenant_id,
      FullName.new('Zoe', 'Doe'),
      contact_information_2
    )
  end

  def registration_invitation_entity_for(a_tenant)
    registration_invitation = a_tenant
      .offer_registration_invitation("Today-and-Tomorrow #{Time.now.to_i}")
      .starting_at(Date.today)
      .ending_at(Date.tomorrow)

    registration_invitation
  end

  def tenant_aggregate
    @tenant ||= begin
      tenant_id = DomainRegistry.tenant_repository.next_identity

      tenant = Tenant.new(
        tenant_id: tenant_id,
        name: FIXTURE_TENANT_NAME,
        description: FIXTURE_TENANT_DESCRIPTION,
        active: true
      )

      DomainRegistry.tenant_repository.add(tenant)

      tenant
    end
  end

  def user_aggregate
    tenant = tenant_aggregate

    registration_invitation = registration_invitation_entity_for(tenant)

    user = tenant.register_user(
      invitation_identifier: registration_invitation.invitation_id,
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity_for(tenant)
    )

    user
  end

  def user_aggregate_2
    tenant = tenant_aggregate

    registration_invitation = registration_invitation_entity_for(tenant)

    user = tenant.register_user(
      invitation_identifier: registration_invitation.invitation_id,
      username: FIXTURE_USERNAME_2,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity_2_for(tenant)
    )

    user
  end
end