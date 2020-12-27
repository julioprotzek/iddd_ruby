class PostalAddress
  include Assertion

  attr_reader :street_address, :city, :state_province, :postal_code, :country_code

  def initialize(street_address, city, state_province, postal_code, country_code)
    self.street_address = street_address
    self.city = city
    self.state_province = state_province
    self.postal_code = postal_code
    self.country_code= country_code
  end

  def ==(other)
    self.class == other.class &&
    self.street_address == other.street_address &&
    self.city == other.city &&
    self.state_province == other.state_province &&
    self.postal_code == other.postal_code &&
    self.country_code == other.country_code
  end

  private

  def street_address=(street_address)
    assert_presence(street_address, 'The street address is required.')
    assert_length(street_address, 1, 100, 'The street address must be 100 characters or less.')

    @street_address = street_address
  end

  def city=(city)
    assert_presence(city, 'The city is required.')
    assert_length(city, 1, 100, 'The city must be 100 characters or less.')

    @city = city
  end

  def state_province=(state_province)
    assert_presence(state_province, 'The state/province is required.')
    assert_length(state_province, 1, 100, 'The state/province must be 100 characters or less.')

    @state_province = state_province
  end

  def postal_code=(postal_code)
    assert_presence(postal_code, 'The postal code is required.')
    assert_length(postal_code, 5, 12, 'The postal code must be 12 characters or less.')

    @postal_code = postal_code
  end

  def country_code=(country_code)
    assert_presence(country_code, 'The country code is required.')
    assert_length(country_code, 2, 2, 'The country code must be two characters or less.')

    @country_code = country_code
  end
end