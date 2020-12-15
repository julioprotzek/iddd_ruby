require './test/test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    @full_name = FullName.new('Zoe', 'Doe')
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

  test 'valid person' do
    person = Person.new(@full_name, @contact_information)

    assert_equal 'Zoe Doe', person.full_name.as_formatted_name
    assert_equal 'zoe@example.com', person.contact_information.email_address.address
  end

  test 'full name is required' do
    error = assert_raises ArgumentError do
      Person.new(
        nil,
        @contact_information
      )
    end

    assert_equal 'The person name is required', error.message
  end

  test 'contact information is required' do
    error = assert_raises ArgumentError do
      Person.new(
        @full_name,
        nil
      )
    end

    assert_equal 'The person contact information is required', error.message
  end

  test 'equality' do
    assert_equal Person.new(@full_name, @contact_information), Person.new(@full_name, @contact_information)
    assert_not_equal Person.new(FullName.new('John', 'Doe'), @contact_information), Person.new(@full_name, @contact_information)
  end
end