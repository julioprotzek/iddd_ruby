class ChangeSecondaryPhoneCommand
  attr_accessor :tenant_id, :username, :phone_number

  def initialize(tenant_id:, username:, phone_number:)
    @tenant_id = tenant_id
    @username = username
    @phone_number = phone_number
  end
end