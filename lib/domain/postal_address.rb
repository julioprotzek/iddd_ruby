class PostalAddress
  include Concerns::Assertion

  attr_reader :street_address, :city, :state_province, :postal_code, :country_code

  def initialize(a_street_address, a_city, a_state_province, a_postal_code, a_country_code)
    self.street_address = a_street_address 
    self.city = a_city 
    self.state_province = a_state_province 
    self.postal_code = a_postal_code 
    self.country_code= a_country_code
  end

  def street_address=(a_street_address)
    assert_presence(a_street_address, 'The street address is required.')
    assert_length(a_street_address, 1, 100, 'The street address must be 100 characters or less.')

    @street_address = a_street_address
  end

  def city=(a_city)
    assert_presence(a_city, 'The city is required.')
    assert_length(a_city, 1, 100, 'The city must be 100 characters or less.')
    
    @city = a_city
  end
  
  def state_province=(a_state_province)
    assert_presence(a_state_province, 'The state/province is required.')
    assert_length(a_state_province, 1, 100, 'The state/province must be 100 characters or less.')

    @state_province = a_state_province
  end

  def postal_code=(a_postal_code)
    assert_presence(a_postal_code, 'The postal code is required.')
    assert_length(a_postal_code, 5, 12, 'The postal code must be 12 characters or less.')
    
    @postal_code = a_postal_code
  end
  
  def country_code=(a_country_code)
    assert_presence(a_country_code, 'The country code is required.')
    assert_length(a_country_code, 2, 2, 'The country code must be two characters or less.')

    @country_code = a_country_code
  end

  def ==(other)
    self.class == other.class && 
    self.street_address == other.street_address &&
    self.city == other.city &&
    self.state_province == other.state_province &&
    self.postal_code == other.postal_code &&
    self.country_code == other.country_code
  end
end