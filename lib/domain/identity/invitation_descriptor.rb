class InvitationDescriptor
  include Assertion

  attr_reader :tenant_id, :invitation_id, :description, :starting_at, :ending_at

  def initialize(a_tenant_id, an_invitation_id, a_description, a_starting_at, and_ending_at)
    assert_presence(a_tenant_id, 'The tenant id is required.')
    @tenant_id = a_tenant_id

    assert_presence(an_invitation_id, 'The invitation id is required.')
    @invitation_id = an_invitation_id

    assert_presence(a_description, 'The description is required.')
    @description = a_description

    @starting_at = a_starting_at
    @ending_at  = an_ending_at
  end

  def ==(other)
    self.class == other.class &&
    self.tenant_id == other.tenant_id &&
    self.invitation_id == other.invitation_id &&
    self.starting_at == other.starting_at &&
    self.ending_at == other.ending_at
  end
end