require './test/test_helper'

class UserTest < ActiveSupport::TestCase
  FIRST_NAME = 'Zoe'
  LAST_NAME = 'Doe'
  MARRIED_LAST_NAME = 'Jones-Doe'

  setup do
    DomainEventPublisher.instance.reset

    @user = User.new(
      Person.new(
        FullName.new(FIRST_NAME, LAST_NAME),
        ContactInformation.new(
          EmailAddress.new('zoe@example.com'),
          PostalAddress.new(
            '123 Pearl Street',
            'Boulder',
            'CO',
            '80301',
            'US'
          ),
          Telephone.new('303-555-1210'),
          Telephone.new('777-123-1011')
        )
      )
    )
  end

  test 'user person contact information changed' do    
    assert_equal 'zoe@example.com', @user.person.contact_information.email_address.address

    handled = false

    DomainEventPublisher.instance.subscribe(PersonContactInformationChanged) do |a_domain_event|
      assert_equal 'johnny@example.com', a_domain_event.contact_information.email_address.address
      handled = true
    end

    @user.change_person_contact_information(ContactInformation.new(
      EmailAddress.new('johnny@example.com'),
      PostalAddress.new(
        '123 Pearl Street',
        'Boulder',
        'CO',
        '80301',
        'US'
      ),
      Telephone.new('303-555-1210'),
      Telephone.new('777-123-1011')
    ))
    assert_equal 'johnny@example.com', @user.person.contact_information.email_address.address

    assert_equal true, handled
  end

  test 'user person name changed' do    
    assert_equal LAST_NAME, @user.person.name.last_name

    handled = false

    DomainEventPublisher.instance.subscribe(PersonNameChanged) do |a_domain_event|
      assert_equal FIRST_NAME, a_domain_event.name.first_name
      assert_equal MARRIED_LAST_NAME, a_domain_event.name.last_name
      handled = true
    end

    @user.change_person_name(FullName.new(FIRST_NAME, MARRIED_LAST_NAME))
    assert_equal MARRIED_LAST_NAME, @user.person.name.last_name

    assert_equal true, handled
  end
end