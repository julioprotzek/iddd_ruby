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
    DomainEventPublisher.publish(
      UserRegistered.new(
        username: username,
        name: person.name,
        email_address: person.contact_information.email_address
      )
    )
  end

  def change_password(from:, to:)
    assert_presence(from, 'Current and new password must be provided.')
    assert_equal(@password, from, 'Current password not confirmed')
    assert_not_equal(from, to, 'The password is unchanged.')
    self.password = to

    DomainEventPublisher.publish(UserPasswordChanged.new(username: username))
  end

  def change_person_name(name)
    @person.change_name(name)
  end

  def change_person_contact_information(contact_information)
    @person.change_contact_information(contact_information)
  end

  def define_enablement(enablement)
    self.enablement = enablement
    DomainEventPublisher.publish(
      UserEnablementChanged.new(
        username: username,
        enablement: enablement
      )
    )
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

  def enabled?
    @enablement.enablement_enabled?
  end

  def person=(person)
    assert_presence_kind_of(person, Person, 'The person is required.')
    person.internal_only_user = self
    @person = person
  end

  def internal_access_only_encrypted_password
    @password
  end

  def as_member
    GroupMember.new(
      tenant_id: tenant_id,
      name: username,
      type: self.class.name
    )
  end

  private

  def tenant_id=(tenant_id)
    assert_presence(tenant_id, 'The tenant id is required.')
    @tenant_id = tenant_id
  end

  def username=(username)
    assert_presence(username, 'The username is required.')
    @username = username
  end

  def password=(plain_text_password)
    assert_presence(plain_text_password, 'The password is required.')
    @password = protect_password(plain_text_password)
  end

  def enablement=(enablement)
    assert_presence(enablement, 'The enablement is required.')
    @enablement = enablement
  end

  def protect_password(plain_text_password)
    assert_passwod_not_weak(plain_text_password, 'The password must be stronger.')
    assert_not_equal(plain_text_password, username, 'Username and password must not be the same.')

    encrypt(plain_text_password)
  end

  def assert_passwod_not_weak(password, message)
    raise ArgumentError.new(message) if DomainRegistry.password_service.weak?(password)
  end
end