class ProvisionGroupCommand
  attr_accessor :tenant_id, :group_name, :description

  def initialize(tenant_id:, group_name:, description:)
    @tenant_id = tenant_id
    @group_name = group_name
    @description = description
  end
end