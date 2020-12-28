class ChangeUserPersonalNameCommand
  attr_accessor :tenant_id, :username, :first_name, :last_name

  def initialize(tenant_id:, username:, first_name:, last_name:)
    @tenant_id = tenant_id
    @username = username
    @first_name = first_name
    @last_name = last_name
  end
end