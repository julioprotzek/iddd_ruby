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

  private

  attr_reader :group_repository, :role_repository, :tenant_repository, :user_repository
end