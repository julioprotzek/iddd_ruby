class AccessApplicationService
  def initialize(group_repository:, role_repository:, tenant_repository:, user_repository:, group_member_service:)
    @group_repository = group_repository
    @role_repository = role_repository
    @tenant_repository = tenant_repository
    @user_repository = user_repository
    @group_member_service = group_member_service
  end

  def assign_user_to_role(command)
    tenant_id = TenantId.new(command.tenant_id)
    user = user_repository.find_by(tenant_id: tenant_id, username: command.username)
    role = role_repository.role_named(tenant_id, command.role_name)

    if user.present? && role.present?
      role.assign_user(user)
      role_repository.update(role)
    end
  end

  def user_in_role?(**attrs)
    user_in_role(**attrs).present?
  end

  def provision_role(command)
    tenant_id = TenantId.new(command.tenant_id)
    tenant = tenant_repository.tenant_of_id(tenant_id)

    role = tenant.provision_role(
      name: command.role_name,
      description: command.role_description,
      supports_nesting: command.role_supports_nesting?
    )

    role_repository.create(role)
  end

  def assign_group_to_role(command)
    tenant_id = TenantId.new(command.tenant_id)
    group = group_repository.group_named(tenant_id, command.group_name)
    role = role_repository.role_named(tenant_id, command.role_name)

    if group.present? && role.present?
      role.assign_group(group, group_member_service)
    end
  end

  def user_in_role(tenant_id:, username:, role_name:)
    user_in_role = nil

    tenant_id = TenantId.new(tenant_id)
    user = user_repository.find_by(tenant_id: tenant_id, username: username)

    if user.present?
      role = role_repository.role_named(tenant_id, role_name)

      if role.present?
        group_member_service = GroupMemberService.new(
          user_repository: user_repository,
          group_repository: group_repository
        )

        user_in_role = user if role.in_role?(user, group_member_service)
      end
    end

    user_in_role
  end

  private

  attr_reader :group_repository, :role_repository, :tenant_repository, :user_repository, :group_member_service
end