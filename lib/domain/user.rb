class User
  attr_reader :person

  def initialize(a_person)
    @person = a_person
  end

  def change_person_name(a_full_name)
    @person.change_name(a_full_name)
  end
end