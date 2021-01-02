require './test/test_helper'

class ApplicationServiceTest < ActiveSupport::TestCase
  FIXTURE_GROUP_NAME = 'Test Group'
  FIXTURE_PASSWORD = 'SecretPassword!'
  FIXTURE_ROLE_NAME = 'Test Role'
  FIXTURE_TENANT_DESCRIPTION = 'This is a test tenant'
  FIXTURE_TENANT_NAME = 'Test tenant'
  FIXTURE_USER_EMAIL_ADDRESS = 'jdoe@example.com'
  FIXTURE_USER_EMAIL_ADDRESS_2 = 'zdoe@example.com'
  FIXTURE_USERNAME = 'jdoe'
  FIXTURE_USERNAME_2 = 'zdoe'

  setup do
    DomainEventPublisher.reset
    event_store.clean
    DomainRegistry.stubs(:group_repository).returns(InMemoryGroupRepository.new)
    DomainRegistry.group_repository.clean
    DomainRegistry.role_repository.clean
    DomainRegistry.tenant_repository.clean
    DomainRegistry.user_repository.clean
  end

  def event_store
    @event_store ||= InMemoryEventStore.new
  end

  def group_1_aggregate
    tenant_aggregate.provision_group(name: FIXTURE_GROUP_NAME + ' 1', description: 'A test group 1.')
  end

  def group_2_aggregate
    tenant_aggregate.provision_group(name: FIXTURE_GROUP_NAME + ' 2', description: 'A test group 2.')
  end

  def role_aggregate
    tenant_aggregate.provision_role(name: FIXTURE_ROLE_NAME, description: 'A test role.', supports_nesting: true)
  end

  def tenant_aggregate
    @active_tenant ||= DomainRegistry
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
        primary_phone: PhoneNumber.new('303-555-1210'),
        secondary_phone: PhoneNumber.new('777-123-1011')
      )
  end

  def user_aggregate
    tenant = tenant_aggregate
    invitation = tenant.offer_registration_invitation('open-ended').open_ended

    tenant.register_user(
      invitation_identifier: invitation.invitation_id,
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.indefinite_enablement,
      person: Person.new(
        tenant.tenant_id,
        FullName.new('John', 'Doe'),
        ContactInformation.new(
          EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
          PostalAddress.new(
            '123 Pearl Street',
            'Boulder',
            'CO',
            '80301',
            'US'
          ),
          PhoneNumber.new('303-555-1210'),
          PhoneNumber.new('777-123-1011')
        )
      )
    )
  end

end