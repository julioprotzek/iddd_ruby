class User
  include Assertion

  attr_reader :tenant_id, :username, :person, :enablement

  delegate :encrypt, to: DomainRegistry.encryption_service

  def initialize(tenant_id:, username:, password:, enablement:, person: )
    self.tenant_id = tenant_id
    self.username = username
    self.password = password
    self.enablement = enablement
    self.person = person
    DomainEventPublisher.instance.publish(UserRegistered.new(username, person.name, person.contact_information.email_address))
  end

  def change_password(from:, to:)
    assert_presence(from, 'Current and new password must be provided.')
    assert_equal(@password, from, 'Current password not confirmed')
    assert_not_equal(from, to, 'The password is unchanged.')
    self.password = to

    DomainEventPublisher.instance.publish(UserPasswordChanged.new(username))
  end

  def change_person_name(a_name)
    @person.change_name(a_name)
  end

  def change_person_contact_information(a_contact_information)
    @person.change_contact_information(a_contact_information)
  end

  def define_enablement(an_enablement)
    self.enablement = an_enablement
    DomainEventPublisher.instance.publish(UserEnablementChanged.new(username, an_enablement))
  end

  def user_descriptor
    UserDescriptor.new(
      tenant_id,
      username,
      person.email_address.address
    )
  end

  def ==(other)
    self.class == other.class &&
    self.tenant_id == other.tenant_id &&
    self.username == other.username
  end

  def eql?(other)
    self == other
  end

  def tenant_id=(an_tenant_id)
    assert_presence(an_tenant_id, 'The tenant id is required.')
    @tenant_id = an_tenant_id
  end

  def username=(an_username)
    assert_presence(an_username, 'The username is required.')
    @username = an_username
  end

  def password=(a_plain_text_password)
    assert_presence(a_plain_text_password, 'The password is required.')
    @password = protect_password(a_plain_text_password)
  end

  def enablement=(an_enablement)
    assert_presence(an_enablement, 'The enablement is required.')
    @enablement = an_enablement
  end

  def enabled?
    @enablement.enablement_enabled?
  end

  def person=(a_person)
    assert_presence_kind_of(a_person, Person, 'The person is required.')
    a_person.internal_only_user = self
    @person = a_person
  end

  def internal_access_only_encrypted_password
    @password
  end

  private

  def protect_password(a_plain_text_password)
    assert_passwod_not_weak(a_plain_text_password, 'The password must be stronger.')
    assert_not_equal(a_plain_text_password, username, 'Username and password must not be the same.')

    encrypt(a_plain_text_password)
  end

  def assert_passwod_not_weak(a_password, message)
    raise ArgumentError.new(message) if DomainRegistry.password_service.weak?(a_password)
  end
end