class DefineUserEnablementCommand
  attr_accessor :tenant_id, :username, :enabled, :start_at, :end_at

  def initialize(tenant_id:, username:, enabled:, start_at:, end_at:)
    @tenant_id = tenant_id
    @username = username
    @enabled = enabled
    @start_at = start_at
    @end_at = end_at
  end
end