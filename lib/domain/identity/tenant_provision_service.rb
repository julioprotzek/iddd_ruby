class TenantProvisionService
  attr_reader :tenant_repository, :user_repository, :role_repository
  def initialize(tenant_repository:, user_repository:, role_repository: )
    @tenant_repository = tenant_repository
    @user_repository = user_repository
    @role_repository = role_repository
  end

  def provision_tenant(name:, description:, administrator_name:, email_address:, postal_address:, primary_phone:, secondary_phone: nil)
    tenant = Tenant.new(
      tenant_id: @tenant_repository.next_identity,
      name: name,
      description: description,
      active: true
    )

    tenant_repository.add(tenant)

    register_administrator_for(tenant, administrator_name, email_address, postal_address, primary_phone, secondary_phone)

    DomainEventPublisher.publish(TenantProvisioned.new(tenant_id: tenant.tenant_id))

    tenant
  end

  private

  def register_administrator_for(tenant, administrator_name, email_address, postal_address, primary_phone, secondary_phone)
    invitation = tenant.offer_registration_invitation('init').open_ended

    strong_password = DomainRegistry.password_service.generate_strong_password

    admin_user = tenant.register_user(
      invitation_identifier: invitation.invitation_id,
      username: 'admin',
      password: strong_password,
      enablement: Enablement.indefinite_enablement,
      person: Person.new(
        tenant_id: tenant.tenant_id,
        name: administrator_name,
        contact_information: ContactInformation.new(
          email_address: email_address,
          postal_address: postal_address,
          primary_phone: primary_phone,
          secondary_phone: secondary_phone
        )
      )
    )

    tenant.withdraw_invitation(invitation.invitation_id)
    user_repository.add(admin_user)
    admin_role = tenant.provision_role(
      name: 'Administrator',
      description: "Default #{tenant.name} administrator.",

    )
    admin_role.assign_user(admin_user)
    role_repository.add(admin_role)

    DomainEventPublisher.publish(
      TenantAdministratorRegistered.new(
        tenant_id: tenant.tenant_id,
        tenant_name: tenant.name,
        administrator_name: administrator_name,
        email_address: email_address,
        username: admin_user.username,
        temporary_password: strong_password
      )
    )
  end
end