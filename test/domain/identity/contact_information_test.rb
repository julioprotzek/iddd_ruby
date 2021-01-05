require './test/domain/identity_access_test'

class ContactInformationTest < IdentityAccessTest
  FIXTURE_POSTAL_ADDRESS = PostalAddress.new(
    street_address: '123 Pearl Street',
    city: 'Boulder',
    state_province: 'CO',
    postal_code: '80301',
    country_code: 'US'
  )

  test 'valid contact information' do
    assert_equal EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS), contact_information.email_address
    assert_equal PostalAddress.new(
      street_address: '123 Pearl Street',
      city: 'Boulder',
      state_province: 'CO',
      postal_code: '80301',
      country_code: 'US'
    ), contact_information.postal_address

    assert_equal PhoneNumber.new('303-555-1210'), contact_information.primary_phone
    assert_equal PhoneNumber.new('777-123-1011'), contact_information.secondary_phone
  end

  test 'validations' do
    assert_validates_presence :email_address, error_message: 'The email address is required.'
    assert_validates_presence :postal_address, error_message: 'The postal address is required.'
    assert_validates_presence :primary_phone, error_message: 'The primary telephone is required.'
  end

  test 'change email address' do
    changed_contact_information = contact_information.change_email_address(EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS_2))
    assert_equal EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS_2), changed_contact_information.email_address
  end

  test 'change postal address' do
    changed_contact_information = contact_information.change_postal_address(PostalAddress.new(
      street_address: '555 Other Street',
      city: 'Boulder',
      state_province: 'CO',
      postal_code: '80602',
      country_code: 'US'
    ))
    assert_equal PostalAddress.new(
      street_address: '555 Other Street',
      city: 'Boulder',
      state_province: 'CO',
      postal_code: '80602',
      country_code: 'US'
    ), changed_contact_information.postal_address
  end

  test 'change primary telephone' do
    changed_contact_information = contact_information.change_primary_phone(PhoneNumber.new('333-123-0000'))
    assert_equal PhoneNumber.new('333-123-0000'), changed_contact_information.primary_phone
  end

  test 'change secondary telephone' do
    changed_contact_information = contact_information.change_secondary_phone(PhoneNumber.new('333-123-0000'))
    assert_equal PhoneNumber.new('333-123-0000'), changed_contact_information.secondary_phone
  end

  test 'equality' do
    assert_equal ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    ), ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    )

    assert_not_equal ContactInformation.new(
      email_address: EmailAddress.new('john@example.com'),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    ), ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    )

    assert_not_equal ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: PostalAddress.new(
        street_address: '333 Other Street',
        city: 'Boulder',
        state_province: 'CO',
        postal_code: '80301',
        country_code: 'US'
      ),
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    ), ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('(555) 000-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    )

    assert_not_equal ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('(555) 777-1212')
    ), ContactInformation.new(
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    )
  end

  def assert_validates_presence(attr_name, error_message:)
    args = {
      email_address: EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
      postal_address: FIXTURE_POSTAL_ADDRESS,
      primary_phone: PhoneNumber.new('303-555-1210'),
      secondary_phone: PhoneNumber.new('303-555-1212')
    }

    args[attr_name] = nil

    error = assert_raises ArgumentError do
      ContactInformation.new(args)
    end

    assert_equal error.message, error_message
  end
end