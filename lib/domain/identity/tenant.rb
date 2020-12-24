class Tenant
  include Assertion

  attr_reader :tenant_id, :name, :description, :registration_invitations

  def initialize(tenant_id: , name: , description: , active: false)
    @registration_invitations = Set.new

    assert_presence(tenant_id, 'TenantId is required.')
    @tenant_id = tenant_id

    assert_presence(name, 'Tenant name is required.')
    assert_length(name, 1, 100, 'Tenant name must be 100 characters or less.')
    @name = name

    assert_presence(description, 'Tenant description is required.')
    assert_length(name, 1, 100, 'Tenant description must be 100 characters or less.')
    @description = description

    @active = active
  end

  def all_available_registration_invitations
    assert_tenant_is_active

    registration_invitations.select(&:available?)
  end

  def all_unavailable_registration_invitations
    assert_tenant_is_active

    registration_invitations.excluding(&:available?)
  end

  def active?
    @active
  end

  def registration_available_through?(a_invitation_identifier)
    assert_tenant_is_active

    invitation = find_invitation_by_indentifier(a_invitation_identifier)
    invitation.present? && invitation.available?
  end

  def offer_registration_invitation(a_description)
    assert_tenant_is_active
    assert(!registration_available_through?(a_description), 'Invitation already exists.')

    invitation = RegistrationInvitation.new(
      tenant_id: tenant_id,
      invitation_id: SecureRandom.uuid,
      description: a_description
    )

    registration_invitations << invitation

    invitation
  end

  def provision_role(name:, description:, supports_nesting: false)
    assert_tenant_is_active

    role = Role.new(
      tenant_id,
      name,
      description,
      supports_nesting
    )

    DomainEventPublisher.instance.publish(RoleProvisioned.new(tenant_id, name))

    role
  end

  def redefine_registration_invitation_as(an_invitation_identifier)
    assert_tenant_is_active

    invitation = find_invitation_by_indentifier(an_invitation_identifier)

    invitation.redefine_as.open_ended if invitation.present?

    invitation
  end

  def register_user(invitation_identifier:, username:, password:, enablement:, person:)
    assert_tenant_is_active

    if registration_available_through?(invitation_identifier)
      person.tenant_id = tenant_id
      User.new(
        tenant_id: tenant_id,
        username: username,
        password: password,
        enablement: enablement,
        person: person
      )
    end
  end

  def withdraw_invitation(an_invitation_identifier)
    invitation = find_invitation_by_indentifier(an_invitation_identifier)
    registration_invitations.delete(invitation)
  end

  private

  def find_invitation_by_indentifier(an_invitation_identifier)
    registration_invitations.find{ |an_invitation| an_invitation.identified_by?(an_invitation_identifier) }
  end

  def assert_tenant_is_active
    assert(active?, 'Tenant is not active.')
  end
end