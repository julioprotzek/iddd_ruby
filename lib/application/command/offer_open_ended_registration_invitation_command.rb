class OfferOpenEndedRegistrationInvitationCommand
  attr_reader :tenant_id, :description

  def initialize(tenant_id:, description:)
    @tenant_id = tenant_id
    @description = description
  end
end