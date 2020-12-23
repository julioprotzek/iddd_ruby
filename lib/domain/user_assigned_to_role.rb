class UserAssignedToRole
  attr_reader :version, :occurred_at, :tenant_id, :name, :username, :first_name, :last_name, :email_address

  def initialize(a_tenant_id, a_name, an_username, a_first_name, a_last_name, an_email_address)
    @version = 1
    @occurred_at = Time.now
    @tenant_id = a_tenant_id
    @name = a_name
    @username = an_username
    @first_name = a_first_name
    @last_name = a_last_name
    @email_address = an_email_address
  end
end