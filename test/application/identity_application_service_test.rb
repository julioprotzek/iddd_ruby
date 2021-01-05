require './test/application/application_service_test'

class IdentityApplicationServiceTest < ApplicationServiceTest
  setup do
    # DomainRegistry.stubs(:group_repository).returns(ActiveRecord::GroupRepository.new)
    DomainRegistry.stubs(:group_repository).returns(InMemory::GroupRepository.new)
  end

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

    parent_group = DomainRegistry.group_repository.reload(parent_group)
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
    parent_group = DomainRegistry.group_repository.add(parent_group)

    ApplicationServiceRegistry.identity_application_service.add_user_to_group(
      AddUserToGroupCommand.new(
        tenant_id: child_group.tenant_id.id,
        group_name: child_group.name,
        username: user.username
      )
    )

    child_group = DomainRegistry.group_repository.reload(child_group)

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

  test 'deactivate tenant' do
    tenant = tenant_aggregate
    assert tenant.active?

    ApplicationServiceRegistry.identity_application_service.deactivate_tenant(
      DeactivateTenantCommand.new(
        tenant_id: tenant.tenant_id.id
      )
    )

    changed_tenant = DomainRegistry.tenant_repository.tenant_of_id(tenant.tenant_id)

    assert changed_tenant.present?
    assert_equal changed_tenant.name, tenant.name
    assert !changed_tenant.active?
  end

  test 'change user contact information' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    ApplicationServiceRegistry.identity_application_service.change_user_contact_information(
      ChangeContactInfoCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        email_address: 'mynewemailaddress@example.com',
        primary_phone: '777-555-1211',
        secondary_phone: '777-555-1212',
        street_address: '123 Pine Street',
        city: 'Loveland',
        state_province: 'CO',
        postal_code: '80771',
        country_code: 'US'
      )
    )

    changed_user = DomainRegistry
      .user_repository
      .find_by(tenant_id: user.tenant_id, username: user.username)

    assert_not_nil changed_user
    assert_equal 'mynewemailaddress@example.com', changed_user.person.email_address.address
    assert_equal '777-555-1211', changed_user.person.contact_information.primary_phone.number
    assert_equal '777-555-1212', changed_user.person.contact_information.secondary_phone.number
    assert_equal '123 Pine Street', changed_user.person.contact_information.postal_address.street_address
    assert_equal 'Loveland', changed_user.person.contact_information.postal_address.city
  end

  test 'change user email address' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    ApplicationServiceRegistry.identity_application_service.change_user_email_address(
      ChangeEmailAddressCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        email_address: 'mynewemailaddress@example.com'
      )
    )

    changed_user = DomainRegistry
      .user_repository
      .find_by(tenant_id: user.tenant_id, username: user.username)

    assert_not_nil changed_user
    assert_equal 'mynewemailaddress@example.com', changed_user.person.email_address.address
  end

  test 'change user postal address' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    ApplicationServiceRegistry.identity_application_service.change_user_postal_address(
      ChangePostalAddressCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        street_address: '123 Pine Street',
        city: 'Loveland',
        state_province: 'CO',
        postal_code: '80771',
        country_code: 'US'
      )
    )

    changed_user = DomainRegistry
      .user_repository
      .find_by(tenant_id: user.tenant_id, username: user.username)

    assert_not_nil changed_user
    assert_equal '123 Pine Street', changed_user.person.contact_information.postal_address.street_address
    assert_equal 'Loveland', changed_user.person.contact_information.postal_address.city
  end

  test 'change user primary phone' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    ApplicationServiceRegistry.identity_application_service.change_user_primary_phone(
      ChangePrimaryPhoneCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        phone_number: '888-555-1211'
      )
    )

    changed_user = DomainRegistry
      .user_repository
      .find_by(tenant_id: user.tenant_id, username: user.username)

    assert_not_nil changed_user
    assert_equal '888-555-1211', changed_user.person.contact_information.primary_phone.number
  end

  test 'change user secondary phone' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    ApplicationServiceRegistry.identity_application_service.change_user_secondary_phone(
      ChangeSecondaryPhoneCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        phone_number: '888-555-1212'
      )
    )

    changed_user = DomainRegistry
      .user_repository
      .find_by(tenant_id: user.tenant_id, username: user.username)

    assert_not_nil changed_user
    assert_equal '888-555-1212', changed_user.person.contact_information.secondary_phone.number
  end

  test 'change user password' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    ApplicationServiceRegistry.identity_application_service.change_user_password(
      ChangeUserPasswordCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        current_password: FIXTURE_PASSWORD,
        changed_password: "THIS.IS.JOE'S.NEW.PASSWORD"
      )
    )

    user_descriptor = ApplicationServiceRegistry.identity_application_service.authenticate_user(
      AuthenticateUserCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        password: "THIS.IS.JOE'S.NEW.PASSWORD"
      )
    )

    assert_not_nil user_descriptor
    assert_equal user_descriptor.username, user.username
  end

  test 'change user personal name' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    ApplicationServiceRegistry.identity_application_service.change_user_personal_name(
      ChangeUserPersonalNameCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        first_name: 'World',
        last_name: 'Peace'
      )
    )

    changed_user = DomainRegistry.user_repository.find_by(tenant_id: user.tenant_id, username: user.username)
    assert_not_nil changed_user
    assert_equal 'World Peace', changed_user.person.name.as_formatted_name
  end

  test 'define user enablement' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    now = Date.today
    future = Date.today + 1000.years

    ApplicationServiceRegistry.identity_application_service.define_user_enablement(
      DefineUserEnablementCommand.new(
        tenant_id: user.tenant_id.id,
        username: user.username,
        enabled: true,
        start_at: now,
        end_at: future
      )
    )

    changed_user = DomainRegistry.user_repository.find_by(tenant_id: user.tenant_id, username: user.username)
    assert_not_nil changed_user
    assert changed_user.enabled?
  end

  test 'is group member' do
    parent_group = group_1_aggregate
    DomainRegistry.group_repository.add(parent_group)

    child_group = group_2_aggregate
    DomainRegistry.group_repository.add(child_group)

    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    assert_equal 0, parent_group.members.size
    assert_equal 0, child_group.members.size

    parent_group.add_group(child_group, DomainRegistry.group_member_service)
    parent_group = DomainRegistry.group_repository.add(parent_group)
    child_group.add_user(user)
    child_group = DomainRegistry.group_repository.add(child_group)

    assert ApplicationServiceRegistry.identity_application_service.member?(
      tenant_id: parent_group.tenant_id.id,
      group_name: parent_group.name,
      username: user.username
    )

    assert ApplicationServiceRegistry.identity_application_service.member?(
      tenant_id: child_group.tenant_id.id,
      group_name: child_group.name,
      username: user.username
    )
  end

  test 'remove group from group' do
    parent_group = group_1_aggregate
    DomainRegistry.group_repository.add(parent_group)

    child_group = group_2_aggregate
    DomainRegistry.group_repository.add(child_group)

    parent_group.add_group(child_group, DomainRegistry.group_member_service)
    parent_group = DomainRegistry.group_repository.add(parent_group)

    assert_equal 1, parent_group.members.size

    ApplicationServiceRegistry.identity_application_service.remove_group_from_group(
      RemoveGroupFromGroupCommand.new(
        tenant_id: parent_group.tenant_id.id,
        parent_group_name: parent_group.name,
        child_group_name: child_group.name
      )
    )

    parent_group = DomainRegistry.group_repository.reload(parent_group)
    assert_equal 0, parent_group.members.size
  end

  test 'remove user from group' do
    parent_group = group_1_aggregate
    DomainRegistry.group_repository.add(parent_group)

    child_group = group_2_aggregate
    DomainRegistry.group_repository.add(child_group)

    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    parent_group.add_group(child_group, DomainRegistry.group_member_service)
    parent_group = DomainRegistry.group_repository.add(parent_group)
    child_group.add_user(user)
    child_group = DomainRegistry.group_repository.add(child_group)

    assert_equal 1, parent_group.members.size
    assert_equal 1, child_group.members.size
    assert parent_group.member?(user, DomainRegistry.group_member_service)
    assert child_group.member?(user, DomainRegistry.group_member_service)

    ApplicationServiceRegistry.identity_application_service.remove_user_from_group(
      RemoveUserFromGroupCommand.new(
        tenant_id: child_group.tenant_id.id,
        group_name: child_group.name,
        username: user.username
      )
    )

    child_group = DomainRegistry.group_repository.reload(child_group)

    assert_equal 1, parent_group.members.size
    assert_equal 0, child_group.members.size
    assert !parent_group.member?(user, DomainRegistry.group_member_service)
    assert !child_group.member?(user, DomainRegistry.group_member_service)
  end

  test 'query tenant' do
    tenant = tenant_aggregate

    queried_tenant = ApplicationServiceRegistry
      .identity_application_service
      .tenant(tenant.tenant_id.id)

    assert_not_nil queried_tenant
    assert_equal queried_tenant, tenant
  end

  test 'query user' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    queried_user = ApplicationServiceRegistry
      .identity_application_service
      .user(user.tenant_id.id, user.username)

    assert_not_nil queried_user
    assert_equal queried_user, user
  end

  test 'query user descriptor' do
    user = user_aggregate
    DomainRegistry.user_repository.add(user)

    queried_user_descriptor = ApplicationServiceRegistry
      .identity_application_service
      .user_descriptor(user.tenant_id.id, user.username)

    assert_not_nil queried_user_descriptor
    assert_equal queried_user_descriptor, user.user_descriptor
  end
end