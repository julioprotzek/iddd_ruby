class TenantProvisionService
  def initialize(tenant_repository:, user_repository:, role_repository: )
    @tenant_repository = tenant_repository
    @user_repository = user_repository
    @role_repository = role_repository
  end

  def provision_tenant(name: , description: , administrator_name: , email_address: , postal_address: , primary_telephone: , secondary_telephone: nil)
    tenant = Tenant.new(
      tenant_id: @tenant_repository.next_identity,
      name: name,
      description: description,
      active: true
    )

    @tenant_repository.add(tenant)

    register_administrator_for(tenant, administrator_name, email_address, postal_address, primary_telephone, secondary_telephone)

    DomainEventPublisher.publish(TenantProvisioned.new(tenant.tenant_id))

    tenant
  end

  private

  def register_administrator_for(a_tenant, an_administrator_name, an_email_address, a_postal_address, a_primary_telephone, a_secondary_telephone)
    invitation = a_tenant.offer_registration_invitation('init').open_ended

    strong_password = DomainRegistry.password_service.generate_strong_password

    admin_user = a_tenant.register_user(
      invitation_identifier: invitation.invitation_id,
      username: 'admin',
      password: strong_password,
      enablement: Enablement.indefinite_enablement,
      person: Person.new(
        a_tenant.tenant_id,
        an_administrator_name,
        ContactInformation.new(
          an_email_address,
          a_postal_address,
          a_primary_telephone,
          a_secondary_telephone
        )
      )
    )

    a_tenant.withdraw_invitation(invitation.invitation_id)
    @user_repository.add(admin_user)
    admin_role = a_tenant.provision_role(
      name: 'Administrator',
      description: "Default #{a_tenant.name} administrator.",

    )
    admin_role.assign_user(admin_user)
    @role_repository.add(admin_role)

    DomainEventPublisher.publish(TenantAdministratorRegistered.new(
      a_tenant.tenant_id,
      a_tenant.name,
      an_administrator_name,
      an_email_address,
      admin_user.username,
      strong_password
    ))
  end
end