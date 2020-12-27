class UserAssignedToRole
  attr_reader :version, :occurred_at, :tenant_id, :role_name, :username, :first_name, :last_name, :email_address

  def initialize(tenant_id, role_name, username, first_name, last_name, email_address)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = tenant_id
    @role_name = role_name
    @username = username
    @first_name = first_name
    @last_name = last_name
    @email_address = email_address
  end
end