class ChangeUserPasswordCommand
  attr_accessor :tenant_id, :username, :current_password, :changed_password

  def initialize(tenant_id:, username:, current_password:, changed_password:)
    @tenant_id = tenant_id
    @username = username
    @current_password = current_password
    @changed_password = changed_password
  end
end