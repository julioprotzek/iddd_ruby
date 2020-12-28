class RemoveGroupFromGroupCommand
  attr_accessor :tenant_id, :parent_group_name, :child_group_name

  def initialize(tenant_id:, parent_group_name:, child_group_name:)
    @tenant_id = tenant_id
    @parent_group_name = parent_group_name
    @child_group_name = child_group_name
  end
end