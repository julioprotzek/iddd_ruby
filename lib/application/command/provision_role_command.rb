class ProvisionRoleCommand
  attr_accessor :tenant_id, :name, :description, :supports_nesting

  def initialize(tenant_id:, name:, description:, supports_nesting:)
    @tenant_id = tenant_id
    @name = name
    @description = description
    @supports_nesting = supports_nesting
  end

  def supports_nesting?
    @supports_nesting == true
  end
end