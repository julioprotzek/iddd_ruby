class RegistrationInvitation
  include Assertion

  attr_reader :tenant_id, :invitation_id, :description, :starts_at, :ends_at

  def initialize(tenant_id:, invitation_id:, description:)
    assert_presence(tenant_id, 'The tenant id is required')
    @tenant_id = tenant_id

    assert_presence(invitation_id, 'The invitation id is required.')
    assert_length(invitation_id, 1, 36, 'The invitation id must be 36 characters of less.')
    @invitation_id = invitation_id

    assert_presence(description, 'The description is required.')
    assert_length(description, 1, 100, 'The description must be 100 characters of less.')
    @description = description

    assert_valid_invitation_dates
  end

  def available?
    starts_at.nil? && ends_at.nil? || Time.now.between?(starts_at, ends_at)
  end

  def identified_by?(invitation_identification)
    (invitation_id == invitation_identification) ||
    (description.present? && description == invitation_identification)
  end

  def open_ended
    @starts_at = nil
    @ends_at = nil
    self
  end

  def redefine_as
    @starts_at = nil
    @ends_at = nil
    self
  end

  def starting_at(date)
    raise StandardError, 'Cannot set starting-at date after ends-at date.' unless ends_at.nil?

    @starts_at = date

    # temporary if ends_at properly follows, but
    # prevents illegal state if ends_at doesn't follow
    @ends_at = date + 1.day

    self
  end

  def ending_at(date)
    raise StandardError, 'Cannot set ends-at date before starting-at date.' unless ends_at.present?

    @ends_at = date

    self
  end

  def ==(other)
    self.class == other.class &&
    self.tenant_id == other.tenant_id &&
    self.invitation_id == other.invitation_id
  end

  def to_descriptor
    InvitationDescriptor.new(
      tenant_id,
      invitation_id,
      description,
      starts_at,
      ends_at
    )
  end

  private

  def assert_valid_invitation_dates
    # either both dates must be null, or both dates must be set
    if starts_at.nil? && ends_at.nil?
      # valid
    elsif starts_at.nil? || ends_at.nil? && starts_at != ends_at
      raise StandardError, 'This is an open ended invitiation.'
    elsif starts_at > ends_at
      raise StandardError, 'The starting date and time must be before the until date and time.'
    end
  end
end