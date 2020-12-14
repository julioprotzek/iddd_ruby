require './test/test_helper'

class ContactInformationTest < ActiveSupport::TestCase
  test 'valid contact information' do
    contact_information = ContactInformation.new(
      EmailAddress.new('zoe@example.com'),
      PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('303-555-1210'),
      Telephone.new('303-555-1212')
    )

    assert_equal EmailAddress.new('zoe@example.com'), contact_information.email_address
    assert_equal PostalAddress.new(
      '123 Pearl Street',
      'Boulder',
      'CO',
      '80301',
      'US'
    ), contact_information.postal_address

    assert_equal Telephone.new('303-555-1210'), contact_information.primary_telephone
    assert_equal Telephone.new('303-555-1212'), contact_information.secondary_telephone
  end
end