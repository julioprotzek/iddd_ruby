class Person
  include Concerns::Assertion

  attr_reader :full_name, :contact_information

  def initialize(a_full_name, a_contact_information)
    self.full_name = a_full_name
    self.contact_information = a_contact_information
  end

  def full_name=(a_full_name)
    assert_presence(a_full_name, 'The person name is required')
    @full_name = a_full_name
  end
  
  def contact_information=(a_contact_information)
    assert_presence(a_contact_information, 'The person contact information is required')
    @contact_information = a_contact_information
  end

  def ==(other)
    self.class == other.class &&
    self.full_name == other.full_name && 
    self.contact_information == other.contact_information
  end
end