class ProvisionRoleCommand
  attr_accessor :tenant_id, :role_name, :role_description, :role_supports_nesting

  def initialize(tenant_id:, role_name:, role_description:, role_supports_nesting:)
    @tenant_id = tenant_id
    @role_name = role_name
    @role_description = role_description
    @role_supports_nesting = role_supports_nesting
  end

  def role_supports_nesting?
    @role_supports_nesting == true
  end
end