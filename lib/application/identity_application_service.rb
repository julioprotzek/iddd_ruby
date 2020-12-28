class IdentityApplicationService
  def initialize(group_repository:, tenant_repository:, user_repository:)
    @group_repository = group_repository
    @tenant_repository = tenant_repository
    @user_repository = user_repository
  end

  def activate_tenant(command)
    tenant = existing_tenant(command.tenant_id)
    tenant.activate
  end

  def tenant(tenant_id)
    tenant_repository.tenant_of_id(TenantId.new(tenant_id))
  end

  private

  def existing_tenant(tenant_id)
    tenant = tenant(tenant_id)
    raise StandardError, 'Tenant does not exist for ' + tenant_id unless tenant.present?
    tenant
  end

  def authentication_service
    AuthenticationService.new(
      tenant_repository: tenant_repository,
      user_repository: user_repository,
      encryption_service: DomainRegistry.encryption_service
    )
  end

  def group_member_service
    GroupMemberService.new(
      group_repository: group_repository,
      user_repository: user_repository
    )
  end

  attr_reader :group_repository, :tenant_repository, :user_repository
end