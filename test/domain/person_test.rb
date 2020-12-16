require './test/test_helper'

class PersonTest < ActiveSupport::TestCase
  FIRST_NAME = 'Zoe'
  LAST_NAME = 'Doe'
  MARRIED_LAST_NAME = 'Jones-Doe'

  setup do
    DomainEventPublisher.instance.reset
    @name = FullName.new(FIRST_NAME, LAST_NAME)
    @married_name = FullName.new(FIRST_NAME, MARRIED_LAST_NAME)

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
    
    @other_contact_information = ContactInformation.new(
      EmailAddress.new('john@example.com'),
      PostalAddress.new(
        '255 Pearl Street',
        'Boulder',
        'CO',
        '70555',
        'US'
      ),
      Telephone.new('111-555-1210'),
      Telephone.new('111-555-1212')
    )
  end

  test 'valid person' do
    person = Person.new(@name, @contact_information)

    assert_equal 'Zoe Doe', person.name.as_formatted_name
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

  test 'change name' do
    person = Person.new(@name, @contact_information)
    person.change_name(@married_name)

    assert_equal @married_name, person.name
  end

  test 'change contact information' do
    person = Person.new(@name, @contact_information)
    person.change_contact_information(@other_contact_information)

    assert_equal @other_contact_information, person.contact_information
  end

  test 'contact information is required' do
    error = assert_raises ArgumentError do
      Person.new(
        @name,
        nil
      )
    end

    assert_equal 'The person contact information is required', error.message
  end

  test 'equality' do
    assert_equal Person.new(@name, @contact_information), Person.new(@name, @contact_information)
    assert_not_equal Person.new(@married_name, @contact_information), Person.new(@name, @contact_information)
  end
end