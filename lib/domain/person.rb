class Person
  include Concerns::Assertion

  attr_reader :name, :contact_information

  def initialize(a_name, a_contact_information)
    self.name = a_name
    self.contact_information = a_contact_information
  end

  def name=(a_name)
    assert_presence(a_name, 'The person name is required')
    @name = a_name
  end
  
  def contact_information=(a_contact_information)
    assert_presence(a_contact_information, 'The person contact information is required')
    @contact_information = a_contact_information
  end

  def change_name(a_name)
    self.name = a_name
  end

  def change_contact_information(a_contact_information)
    self.contact_information = a_contact_information
  end

  def ==(other)
    self.class == other.class &&
    self.name == other.name && 
    self.contact_information == other.contact_information
  end
end