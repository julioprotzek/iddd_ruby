require './test/test_helper'

class ContactInformationTest < ActiveSupport::TestCase
  setup do
    @contact_information = ContactInformation.new(
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
  end

  test 'valid contact information' do
    assert_equal EmailAddress.new('zoe@example.com'), @contact_information.email_address
    assert_equal PostalAddress.new(
      '123 Pearl Street',
      'Boulder',
      'CO',
      '80301',
      'US'
    ), @contact_information.postal_address

    assert_equal Telephone.new('303-555-1210'), @contact_information.primary_telephone
    assert_equal Telephone.new('303-555-1212'), @contact_information.secondary_telephone
  end

  test 'validations' do
    assert_validates_presence :email_address, error_message: 'The email address is required.'
    assert_validates_presence :postal_address, error_message: 'The postal address is required.'
    assert_validates_presence :primary_telephone, error_message: 'The primary telephone is required.'
  end

  test 'change email address' do
    changed_contact_information = @contact_information.change_email_address(EmailAddress.new('johnny@example.com'))
    assert_equal EmailAddress.new('johnny@example.com'), changed_contact_information.email_address
  end

  test 'change postal address' do
    changed_contact_information = @contact_information.change_postal_address(PostalAddress.new(
      '555 Other Street',
      'Boulder',
      'CO',
      '80602',
      'US'
    ))
    assert_equal PostalAddress.new(
      '555 Other Street',
      'Boulder',
      'CO',
      '80602',
      'US'
    ), changed_contact_information.postal_address
  end

  test 'change primary telephone' do
    changed_contact_information = @contact_information.change_primary_telephone(Telephone.new('333-123-0000'))
    assert_equal Telephone.new('333-123-0000'), changed_contact_information.primary_telephone
  end

  test 'change secondary telephone' do
    changed_contact_information = @contact_information.change_secondary_telephone(Telephone.new('333-123-0000'))
    assert_equal Telephone.new('333-123-0000'), changed_contact_information.secondary_telephone
  end

  test 'equality' do
    assert_equal ContactInformation.new(
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
    ), ContactInformation.new(
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

    assert_not_equal ContactInformation.new(
      EmailAddress.new('john@example.com'),
      PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('303-555-1210'),
      Telephone.new('303-555-1212')
    ), ContactInformation.new(
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

    assert_not_equal ContactInformation.new(
      EmailAddress.new('zoe@example.com'),
      PostalAddress.new(
        '333 Other Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('303-555-1210'),
      Telephone.new('303-555-1212')
    ), ContactInformation.new(
      EmailAddress.new('zoe@example.com'),
      PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('(555) 000-1210'),
      Telephone.new('303-555-1212')
    )

    assert_not_equal ContactInformation.new(
      EmailAddress.new('zoe@example.com'),
      PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('303-555-1210'),
      Telephone.new('(555) 777-1212')
    ), ContactInformation.new(
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
  end


  def assert_validates_presence(attr_name, error_message:)
    args = {
      email_address: EmailAddress.new('zoe@example.com'),
      postal_address: PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      primary_telephone: Telephone.new('303-555-1210'),
      secondary_telephone: Telephone.new('303-555-1212')
    }

    args[attr_name] = nil

    error = assert_raises ArgumentError do
      ContactInformation.new(*args.values)
    end

    assert_equal error.message, error_message
  end
end