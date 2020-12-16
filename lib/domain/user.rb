class User
  include Concerns::Assertion

  attr_reader :username, :person

  delegate :encrypted, to: DomainRegistry.encryption_service

  def initialize(username: , password: , person: )
    self.username = username
    self.password = password
    self.person = person
  end

  def change_password(a_current_password, a_new_password)
    assert_presence(a_current_password, 'Current and new password must be provided.')
    assert_equal(@password, a_current_password, 'Current password not confirmed')
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

  def password=(a_password)
    assert_presence(a_password, 'The password is required.')
    @password = encrypted(a_password)
  end
  
  def person=(a_person)
    assert_presence_kind_of(a_person, Person, 'The person is required.')
    @person = a_person
  end

  def internal_access_only_encrypted_password
    @password
  end
end