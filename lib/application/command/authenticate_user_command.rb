class AuthenticateUserCommand
  attr_accessor :tenant_id, :username, :password

  def initialize(tenant_id:, username:, password:)
    @tenant_id = tenant_id
    @username = username
    @password = password
  end
end