class IdentityApplicationService
  def initialize(group_repository:, tenant_repository:, user_repository:)
    @group_repository = group_repository
    @tenant_repository = tenant_repository
    @user_repository = user_repository

    # IdentityAccessEventProcessor.register
  end

  def activate_tenant(command)
    tenant = existing_tenant(command.tenant_id)
    tenant.activate
  end

  def add_group_to_group(command)
    parent_group = existing_group(command.tenant_id, command.parent_group_name)
    child_group = existing_group(command.tenant_id, command.child_group_name)
    parent_group.add_group(child_group, group_member_service)
  end

  def add_user_to_group(command)
    user = existing_user(command.tenant_id, command.username)
    group = existing_group(command.tenant_id, command.group_name)
    group.add_user(user)
  end

  def authenticate_user(command)
    authentication_service.authenticate(TenantId.new(command.tenant_id), command.username, command.password)
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

  def deactivate_tenant(command)
    tenant = existing_tenant(command.tenant_id)
    tenant.deactivate
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

  def authentication_service
    DomainRegistry.authentication_service
  end

  def group_member_service
    DomainRegistry.group_member_service
  end

  attr_reader :group_repository, :tenant_repository, :user_repository
end