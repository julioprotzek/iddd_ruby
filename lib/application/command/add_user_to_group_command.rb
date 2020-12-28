class AddUserToGroupCommand
  attr_accessor :tenant_id, :group_name, :username

  def initialize(tenant_id:, group_name:, username:)
    @tenant_id = tenant_id
    @group_name = group_name
    @username = username
  end
end