class TenantAdministratorRegistered
  attr_reader :version, :occurred_at, :tenant_id, :name, :administrator_name, :email_address, :username, :password

  def initialize(a_tenant_id, a_name, an_administrator_name, an_email_address, an_username, a_password)
    @version = 1
    @occurred_at = Time.now

    @tenant_id = a_tenant_id
    @name = a_name
    @administrator_name = an_administrator_name
    @email_address = an_email_address
    @username = an_username
    @password = a_password
  end
end