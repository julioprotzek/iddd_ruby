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
    DomainEventPublisher.reset

    # Comment stubs to test database active record repositories
    # DomainRegistry.stubs(:group_repository).returns(InMemory::GroupRepository.new)
    # DomainRegistry.stubs(:user_repository).returns(InMemory::UserRepository.new)
    DomainRegistry.stubs(:role_repository).returns(InMemory::RoleRepository.new)
    DomainRegistry.stubs(:tenant_repository).returns(InMemory::TenantRepository.new)

    DomainRegistry.group_repository.clean
    DomainRegistry.user_repository.clean
    DomainRegistry.role_repository.clean
    DomainRegistry.tenant_repository.clean
  end

  def contact_information
    ContactInformation.new(
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
  end

  def contact_information_2
    ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS_2),
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
  end

  def person_entity_for(tenant)
    Person.new(
      tenant_id: tenant.tenant_id,
      name: FullName.new(
        first_name: 'John',
        last_name: 'Doe'
      ),
      contact_information: contact_information
    )
  end

  def person_entity_2_for(tenant)
    Person.new(
      tenant_id: tenant.tenant_id,
      name: FullName.new(
        first_name: 'John',
        last_name: 'Doe'
      ),
      contact_information: contact_information_2
    )
  end

  def registration_invitation_entity_for(tenant)
    registration_invitation = tenant
      .offer_registration_invitation("Today-and-Tomorrow #{SecureRandom.rand}")
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