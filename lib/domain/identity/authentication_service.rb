class AuthenticationService
  include Assertion

  def initialize(tenant_repository:, user_repository:, encryption_service:)
    @tenant_repository = tenant_repository
    @user_repository = user_repository
    @encryption_service = encryption_service
  end

  def authenticate(a_tenant_id, an_username, a_password)
    assert_presence(a_tenant_id, 'TenantId must be provided')
    assert_presence(an_username, 'Username must be provided')
    assert_presence(a_password, 'Password must be provided')

    user_descriptor = UserDescriptor.null_descriptor_instance

    tenant = tenant_repository.tenant_of_id(a_tenant_id)

    if tenant&.active?
      user = user_repository.user_from_authentic_credentials(a_tenant_id, an_username, a_password)

      if user&.enabled?
        user_descriptor = user.user_descriptor
      end
    end

    user_descriptor
  end

  private

  attr_reader :tenant_repository, :user_repository, :encryption_service
end