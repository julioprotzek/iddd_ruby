class AccessApplicationService
  def initialize(group_repository:, role_repository:, tenant_repository:, user_repository:)
    @group_repository = group_repository
    @role_repository = role_repository
    @tenant_repository = tenant_repository
    @user_repository = user_repository
  end

  def assign_user_to_role(command)
    tenant_id = TenantId.new(command.tenant_id)
    user = user_repository.find_by(tenant_id: tenant_id, username: command.username)

    if user.present?
      role = role_repository.role_named(tenant_id, command.role_name)
      role&.assign_user(user)
    end
  end

  def user_in_role?(**attrs)
    user_in_role(**attrs).present?
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

  attr_reader :group_repository, :role_repository, :tenant_repository, :user_repository
end