class TenantAdministratorRegistered
  attr_reader :version, :occurred_at, :tenant_id, :name, :administrator_name, :email_address, :username, :password

  def initialize(tenant_id, name, administrator_name, email_address, username, password)
    @version = 1
    @occurred_at = Time.now

    @tenant_id = tenant_id
    @name = name
    @administrator_name = administrator_name
    @email_address = email_address
    @username = username
    @password = password
  end
end