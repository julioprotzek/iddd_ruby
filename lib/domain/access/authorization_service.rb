class AuthorizationService
  include Assertion

  attr_reader :user_repository, :group_repository, :role_repository

  def initialize(user_repository:, group_repository:, role_repository:)
    @user_repository = user_repository
    @group_repository = group_repository
    @role_repository = role_repository
  end

  def username_in_role?(tenant_id, username, role_name)
    assert_presence(tenant_id, 'Tenant Id must not be null.')
    assert_presence(username, 'Username must not be null.')
    assert_presence(role_name, 'Role name must not be null.')

    user = user_repository.find_by(tenant_id: tenant_id, username: username)
    user.present? && user_in_role?(user, role_name)
  end

  def user_in_role?(user, role_name)
    assert_presence(user, 'User must not be null.')
    assert_presence(role_name, 'Role name must not be null.')

    role = role_repository.role_named(user.tenant_id, role_name)
    role.present? && role.in_role?(user, group_member_service)
  end

  private

  def group_member_service
    GroupMemberService.new(user_repository: user_repository, group_repository: group_repository)
  end
end