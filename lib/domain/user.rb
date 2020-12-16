class User
  attr_reader :person

  def initialize(a_person)
    @person = a_person
  end

  def change_person_name(a_name)
    @person.change_name(a_name)
  end

  def change_person_contact_information(a_contact_information)
    @person.change_contact_information(a_contact_information)
  end

  def ==(other)
    self.class == other.class &&
    self.person == other.person
  end
end