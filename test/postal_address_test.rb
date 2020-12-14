require './test/test_helper'

class PostalAddressTest < ActiveSupport::TestCase
  test 'valid post address' do
    a_postal_address = PostalAddress.new(
      '123 Pearl Street',
      'Boulder',
      'CO',
      '80301',
      'US'
    )

    assert_equal '123 Pearl Street', a_postal_address.street_address
    assert_equal 'Boulder', a_postal_address.city
    assert_equal 'CO', a_postal_address.state_province
    assert_equal '80301', a_postal_address.postal_code
    assert_equal 'US', a_postal_address.country_code
  end

  def assert_validates_presence_of(attr_name, error_message:)
    args = {
      street_address: '123 Pearl Street',
      city: 'Boulder',
      state_province: 'CO',
      postal_code: '80301',
      country_code: 'US'
    }
    args[attr_name] = ''

    error = assert_raises ArgumentError do
      PostalAddress.new(*args.values)
    end

    assert_equal error.message, error_message
  end

  def assert_validates_length_of(attr_name, min: , max: , error_message:)
    args = {
      street_address: '123 Pearl Street',
      city: 'Boulder',
      state_province: 'CO',
      postal_code: '80301',
      country_code: 'US'
    }
    args[attr_name] = args[attr_name] + ('o' * max)

    error = assert_raises ArgumentError do
      PostalAddress.new(*args.values)
    end

    assert_equal error.message, error_message
  end

  test 'validations' do
    assert_validates_presence_of :street_address, error_message: 'The street address is required.'
    assert_validates_length_of :street_address, min: 1, max: 100, error_message: 'The street address must be 100 characters or less.'
    
    assert_validates_presence_of :city, error_message: 'The city is required.'
    assert_validates_length_of :city, min: 1, max: 100, error_message: 'The city must be 100 characters or less.'
    
    assert_validates_presence_of :state_province, error_message: 'The state/province is required.'
    assert_validates_length_of :state_province, min: 1, max: 100, error_message: 'The state/province must be 100 characters or less.'

    assert_validates_presence_of :postal_code, error_message: 'The postal code is required.'
    assert_validates_length_of :postal_code, min: 5, max: 12, error_message: 'The postal code must be 12 characters or less.'

    assert_validates_presence_of :country_code, error_message: 'The country code is required.'
    assert_validates_length_of :country_code, min: 2, max: 2, error_message: 'The country code must be two characters or less.'
  end
end

