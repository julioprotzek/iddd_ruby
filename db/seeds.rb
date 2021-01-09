DomainRegistry.group_repository.clean
DomainRegistry.tenant_repository.clean
DomainRegistry.role_repository.clean
DomainRegistry.user_repository.clean

tenant = ApplicationServiceRegistry
  .identity_application_service
  .provision_tenant(
    ProvisionTenantCommand.new(
      tenant_name: 'ACME LLC',
      tenant_description: 'ACME Workspace',
      administrator_first_name: 'John',
      administrator_last_name: 'Doe',
      email_address: 'admin@acme.com',
      primary_phone: '303-555-1210',
      address_street_address: '123 Pearl Street',
      address_city: 'Boulder',
      address_state_province: 'CO',
      address_postal_code: '80301',
      address_country_code: 'US'
    )
  )

invitation = ApplicationServiceRegistry
  .identity_application_service
  .offer_open_ended_registration_invitation(
    OfferOpenEndedRegistrationInvitationCommand.new(
      tenant_id: tenant.tenant_id,
      description: "Zoe's invitation to register as an user to manage the workspace"
    )
  )

manager = ApplicationServiceRegistry
  .identity_application_service
  .register_user(
    RegisterUserCommand.new(
      tenant_id: tenant.tenant_id,
      invitation_identifier: invitation.invitation_id,
      username: 'manager@acme.com',
      password: 'Hey123456',
      first_name: 'Zoe',
      last_name: 'Doe',
      enabled: true,
      start_at: Date.today,
      end_at: Date.today + 1.year,
      email_address: 'manager@acme.com',
      primary_phone: '303-555-1210',
      address_street_address: '123 Pearl Street',
      address_city: 'Boulder',
      address_state_province: 'CO',
      address_postal_code: '80301',
      address_country_code: 'US'
    )
  )

manager_group = ApplicationServiceRegistry
  .identity_application_service
  .provision_group(
    ProvisionGroupCommand.new(
      tenant_id: tenant.tenant_id,
      group_name: 'Managers',
      description: "Manager's group"
    )
  )

ApplicationServiceRegistry
  .identity_application_service
  .add_user_to_group(
    AddUserToGroupCommand.new(
      tenant_id: tenant.tenant_id,
      group_name: manager_group.name,
      username: manager.username
    )
  )

manager_role = ApplicationServiceRegistry
  .access_application_service
  .provision_role(
    ProvisionRoleCommand.new(
      tenant_id: tenant.tenant_id,
      role_name: 'Manager',
      role_description: "Overall workspace manager",
      role_supports_nesting: true
    )
  )

ApplicationServiceRegistry
  .access_application_service
  .assign_group_to_role(
    AssignGroupToRoleCommand.new(
      tenant_id: tenant.tenant_id,
      group_name: manager_group.name,
      role_name: manager_role.name,
    )
  )