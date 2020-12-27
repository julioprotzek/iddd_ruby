class TenantAdministratorRegistered
  attr_reader :version, :occurred_at, :tenant_id, :tenant_name, :administrator_name, :email_address, :username, :temporary_password

  def initialize(tenant_id, tenant_name, administrator_name, email_address, username, temporary_password)
    @version = 1
    @occurred_at = Time.now

    @tenant_id = tenant_id
    @tenant_name = tenant_name
    @administrator_name = administrator_name
    @email_address = email_address
    @username = username
    @temporary_password = temporary_password
  end
end