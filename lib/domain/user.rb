class User
  attr_reader :username, :password, :person

  def initialize(username: , password: , person: )
    @username = username
    @password = password
    @person = person
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
end