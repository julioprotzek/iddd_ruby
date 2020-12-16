class User
  include Concerns::Assertion

  attr_reader :username, :person

  delegate :encrypt, to: DomainRegistry.encryption_service

  def initialize(username: , password: , person: )
    self.username = username
    self.password = password
    self.person = person
    DomainEventPublisher.instance.publish(UserRegistered.new(username, person.name, person.contact_information.email_address))
  end

  def change_password(a_current_password, a_new_password)
    assert_presence(a_current_password, 'Current and new password must be provided.')
    assert_equal(@password, a_current_password, 'Current password not confirmed')
    assert_not_equal(a_current_password, a_new_password, 'The password is unchanged.')
    self.password = a_new_password

    DomainEventPublisher.instance.publish(UserPasswordChanged.new(username))
  end

  def change_person_name(a_name)
    @person.change_name(a_name)
  end

  def change_person_contact_information(a_contact_information)
    @person.change_contact_information(a_contact_information)
  end

  def ==(other)
    self.class == other.class &&
    self.username == other.username
  end

  def username=(a_username)
    assert_presence(a_username, 'The username is required.')
    @username = a_username
  end

  def password=(a_plain_text_password)
    assert_presence(a_plain_text_password, 'The password is required.')
    @password = protect_password(a_plain_text_password)
  end

  def person=(a_person)
    assert_presence_kind_of(a_person, Person, 'The person is required.')
    @person = a_person
  end
  
  def internal_access_only_encrypt_password
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