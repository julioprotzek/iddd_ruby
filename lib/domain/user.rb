class User
  include Concerns::Assertion

  attr_reader :username, :person

  delegate :encrypted, to: DomainRegistry.encryption_service

  def initialize(username: , password: , person: )
    self.username = username
    self.password = protect_password('', password)
    self.person = person
  end

  def change_password(a_current_password, a_new_password)
    assert_presence(a_current_password, 'Current and new password must be provided.')
    assert_equal(@password, a_current_password, 'Current password not confirmed')
    self.password = protect_password(a_current_password, a_new_password)

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

  def password=(a_protected_password)
    assert_presence(a_protected_password, 'The password is required.')
    @password = a_protected_password
  end

  def person=(a_person)
    assert_presence_kind_of(a_person, Person, 'The person is required.')
    @person = a_person
  end
  
  def internal_access_only_encrypted_password
    @password
  end
  
  private

  def protect_password(current_password, a_new_password)
    assert_not_equal(current_password, a_new_password, 'The password is unchanged.')
    assert_passwod_not_weak(a_new_password, 'The password must be stronger.')
    assert_not_equal(a_new_password, username, 'Username and password must not be the same.')

    encrypted(a_new_password)
  end  

  def assert_passwod_not_weak(a_password, message)
    raise ArgumentError.new(message) if DomainRegistry.password_service.weak?(a_password)
  end
end