class ContactInformation
  attr_reader :email_address, :postal_address, :primary_telephone, :secondary_telephone

  def initialize(an_email_address, a_postal_address, a_primary_telephone, a_secondary_telephone)
    @email_address = an_email_address
    @postal_address = a_postal_address
    @primary_telephone = a_primary_telephone
    @secondary_telephone = a_secondary_telephone
  end
end