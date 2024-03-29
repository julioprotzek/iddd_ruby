class IdentityApplicationService
  def initialize(group_repository:, tenant_repository:, user_repository:)
    @group_repository = group_repository
    @tenant_repository = tenant_repository
    @user_repository = user_repository

    IdentityAccessEventProcessor.register
  end

  def activate_tenant(command)
    tenant = existing_tenant(command.tenant_id)
    tenant.activate

    tenant_repository.update(tenant)
  end

  def add_group_to_group(command)
    parent_group = existing_group(command.tenant_id, command.parent_group_name)
    child_group = existing_group(command.tenant_id, command.child_group_name)

    parent_group.add_group(child_group, group_member_service)

    group_repository.update(parent_group)
  end

  def add_user_to_group(command)
    user = existing_user(command.tenant_id, command.username)
    group = existing_group(command.tenant_id, command.group_name)

    group.add_user(user)

    group_repository.update(group)
  end

  def authenticate_user(command)
    authentication_service.authenticate(TenantId.new(command.tenant_id), command.username, command.password)
  end

  def deactivate_tenant(command)
    tenant = existing_tenant(command.tenant_id)
    tenant.deactivate

    tenant_repository.update(tenant)
  end

  def change_user_contact_information(command)
    user = existing_user(command.tenant_id, command.username)
    user.change_person_contact_information(
      ContactInformation.new(
        email_address: EmailAddress.new(command.email_address),
        postal_address: PostalAddress.new(
          street_address: command.street_address,
          city: command.city,
          state_province: command.state_province,
          postal_code: command.postal_code,
          country_code: command.country_code
        ),
        primary_phone: PhoneNumber.new(command.primary_phone),
        secondary_phone: PhoneNumber.new(command.secondary_phone),
      )
    )

    user_repository.update(user)
  end

  def change_user_email_address(command)
    user = existing_user(command.tenant_id, command.username)
    internal_change_user_contact_information(
      user,
      user
        .person
        .contact_information
        .change_email_address(EmailAddress.new(command.email_address))
    )

    user_repository.update(user)
  end

  def change_user_postal_address(command)
    user = existing_user(command.tenant_id, command.username)
    internal_change_user_contact_information(
      user,
      user
        .person
        .contact_information
        .change_postal_address(
          PostalAddress.new(
            street_address: command.street_address,
            city: command.city,
            state_province: command.state_province,
            postal_code: command.postal_code,
            country_code: command.country_code
          )
        )
    )

    user_repository.update(user)
  end

  def change_user_primary_phone(command)
    user = existing_user(command.tenant_id, command.username)
    internal_change_user_contact_information(
      user,
      user
        .person
        .contact_information
        .change_primary_phone(PhoneNumber.new(command.phone_number))
    )

    user_repository.update(user)
  end

  def change_user_secondary_phone(command)
    user = existing_user(command.tenant_id, command.username)
    internal_change_user_contact_information(
      user,
      user
        .person
        .contact_information
        .change_secondary_phone(PhoneNumber.new(command.phone_number))
    )

    user_repository.update(user)
  end

  def change_user_password(command)
    user = existing_user(command.tenant_id, command.username)
    user.change_password(
      from: command.current_password,
      to: command.changed_password
    )

    user_repository.update(user)
  end

  def change_user_personal_name(command)
    user = existing_user(command.tenant_id, command.username)
    user.change_person_name(
      FullName.new(
        first_name: command.first_name,
        last_name: command.last_name
      )
    )

    user_repository.update(user)
  end

  def define_user_enablement(command)
    user = existing_user(command.tenant_id, command.username)
    user.define_enablement(
      Enablement.new(
        enabled: command.enabled,
        start_at: command.start_at,
        end_at: command.end_at
      )
    )
  end

  def member?(tenant_id:, group_name:, username:)
    user = existing_user(tenant_id, username)
    group = existing_group(tenant_id, group_name)
    group.member?(user, group_member_service)
  end

  def provision_group(command)
    tenant = existing_tenant(command.tenant_id)

    group = tenant.provision_group(
      name: command.group_name,
      description: command.description
    )

    group_repository.create(group)

    group
  end

  def provision_tenant(command)
    tenant_provision_service.provision_tenant(
      name: command.tenant_name,
      description: command.tenant_description,
      administrator_name: FullName.new(
        first_name: command.administrator_first_name,
        last_name: command.administrator_last_name
      ),
      email_address: EmailAddress.new(command.email_address),
      postal_address: PostalAddress.new(
        street_address: command.address_street_address,
        city: command.address_city,
        state_province: command.address_state_province,
        postal_code: command.address_postal_code,
        country_code: command.address_country_code,
      ),
      primary_phone: PhoneNumber.new(command.primary_phone),
      secondary_phone: command.secondary_phone.present? ? PhoneNumber.new(command.secondary_phone) : nil
    )
  end

  def offer_open_ended_registration_invitation(command)
    tenant = existing_tenant(command.tenant_id)
    invitation = tenant.offer_registration_invitation(command.description).open_ended
    tenant_repository.update(tenant)
    invitation
  end

  def register_user(command)
    tenant = existing_tenant(command.tenant_id)
    user = tenant.register_user(
      invitation_identifier: command.invitation_identifier,
      username: command.username,
      password: command.password,
      enablement: Enablement.new(
        enabled: command.enabled,
        start_at: command.start_at,
        end_at: command.end_at
      ),
      person: Person.new(
        tenant_id: tenant.tenant_id,
        name: FullName.new(
          first_name: command.first_name,
          last_name: command.last_name
        ),
        contact_information: ContactInformation.new(
          email_address: EmailAddress.new(command.email_address),
          postal_address: PostalAddress.new(
            street_address: command.address_street_address,
            city: command.address_city,
            state_province: command.address_state_province,
            postal_code: command.address_postal_code,
            country_code: command.address_country_code,
          ),
          primary_phone: PhoneNumber.new(command.primary_phone),
          secondary_phone: command.secondary_phone.present? ? PhoneNumber.new(command.secondary_phone) : nil
        )
      )
    )

    if user.present?
      user_repository.create(user)
    else
      raise StandardError, 'User not registered.'
    end

    user
  end

  def remove_group_from_group(command)
    parent_group = existing_group(command.tenant_id, command.parent_group_name)
    child_group = existing_group(command.tenant_id, command.child_group_name)

    parent_group.remove_group(child_group)

    group_repository.update(parent_group)
  end

  def remove_user_from_group(command)
    user = existing_user(command.tenant_id, command.username)
    group = existing_group(command.tenant_id, command.group_name)

    group.remove_user(user)

    group_repository.update(group)
  end

  def tenant(tenant_id)
    tenant_repository.tenant_of_id(TenantId.new(tenant_id))
  end

  def group(tenant_id, group_name)
    group_repository.group_named(TenantId.new(tenant_id), group_name)
  end

  def user(tenant_id, username)
    user_repository.find_by(tenant_id: TenantId.new(tenant_id), username: username)
  end

  def user_descriptor(tenant_id, username)
    user_repository.find_by(tenant_id: TenantId.new(tenant_id), username: username)&.user_descriptor
  end

  private

  def existing_tenant(tenant_id)
    tenant = tenant(tenant_id)

    return tenant if tenant.present?

    raise StandardError, "Tenant does not exist for tenant_id=#{tenant_id.id}"
  end

  def existing_group(tenant_id, group_name)
    group = group(tenant_id, group_name)

    return group if group.present?

    raise StandardError, "Group does not exist for tenant_id=#{tenant_id.id} and username=#{group_name}"
  end

  def existing_user(tenant_id, username)
    user = user(tenant_id, username)

    return user if user.present?

    raise StandardError, "User does not exist for tenant_id=#{tenant_id.id} and username=#{username}"
  end

  def internal_change_user_contact_information(user, contact_information)
    user.person.change_contact_information(contact_information)
  end

  def authentication_service
    DomainRegistry.authentication_service
  end

  def group_member_service
    DomainRegistry.group_member_service
  end

  def tenant_provision_service
    DomainRegistry.tenant_provision_service
  end

  attr_reader :group_repository, :tenant_repository, :user_repository
end