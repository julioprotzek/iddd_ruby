class AuthenticationService
  include Assertion

  def initialize(tenant_repository:, user_repository:, encryption_service:)
    @tenant_repository = tenant_repository
    @user_repository = user_repository
    @encryption_service = encryption_service
  end

  def authenticate(tenant_id, username, password)
    assert_presence(tenant_id, 'TenantId must be provided')
    assert_presence(username, 'Username must be provided')
    assert_presence(password, 'Password must be provided')

    user_descriptor = UserDescriptor.null_descriptor_instance

    tenant = tenant_repository.tenant_of_id(tenant_id)

    if tenant&.active?
      user = user_repository.user_from_authentic_credentials(tenant_id, username, password)

      if user&.enabled?
        user_descriptor = user.user_descriptor
      end
    end

    user_descriptor
  end

  private

  attr_reader :tenant_repository, :user_repository, :encryption_service
end