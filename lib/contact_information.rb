class ContactInformation
  include Concerns::Assertion

  attr_reader :email_address, :postal_address, :primary_telephone, :secondary_telephone

  def initialize(an_email_address, a_postal_address, a_primary_telephone, a_secondary_telephone)
    self.email_address = an_email_address
    self.postal_address = a_postal_address
    self.primary_telephone = a_primary_telephone
    self.secondary_telephone = a_secondary_telephone
  end
  
  def email_address=(an_email_address)
    assert_presence(an_email_address, 'The email address is required.')

    @email_address = an_email_address
  end
  
  def postal_address=(a_postal_address)
    assert_presence(a_postal_address, 'The postal address is required.')

    @postal_address = a_postal_address
  end
  
  def primary_telephone=(a_primary_telephone)
    assert_presence(a_primary_telephone, 'The primary telephone is required.')

    @primary_telephone = a_primary_telephone
  end
  
  def secondary_telephone=(a_secondary_telephone)
    @secondary_telephone = a_secondary_telephone
  end

  def change_email_address(an_email_address)
    self.class.new(
      an_email_address, 
      postal_address, 
      primary_telephone, 
      secondary_telephone
    )
  end

  def change_postal_address(a_postal_address)
    self.class.new(
      email_address, 
      a_postal_address, 
      primary_telephone, 
      secondary_telephone
    )
  end

  def change_primary_telephone(a_primary_telephone)
    self.class.new(
      email_address, 
      postal_address, 
      a_primary_telephone, 
      secondary_telephone
    )
  end

  def change_secondary_telephone(a_secondary_telephone)
    self.class.new(
      email_address, 
      postal_address, 
      primary_telephone, 
      a_secondary_telephone
    )
  end
end