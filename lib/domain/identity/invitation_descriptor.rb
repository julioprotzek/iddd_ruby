class InvitationDescriptor
  include Assertion

  attr_reader :tenant_id, :invitation_id, :description, :starting_at, :ending_at

  def initialize(tenant_id, invitation_id, description, starting_at, and_ending_at)
    assert_presence(tenant_id, 'The tenant id is required.')
    @tenant_id = tenant_id

    assert_presence(invitation_id, 'The invitation id is required.')
    @invitation_id = invitation_id

    assert_presence(description, 'The description is required.')
    @description = description

    @starting_at = starting_at
    @ending_at  = ending_at
  end

  def ==(other)
    self.class == other.class &&
    self.tenant_id == other.tenant_id &&
    self.invitation_id == other.invitation_id &&
    self.starting_at == other.starting_at &&
    self.ending_at == other.ending_at
  end
end