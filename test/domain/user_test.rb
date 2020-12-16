require './test/test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    DomainEventPublisher.instance.reset
    @person = Person.new(
      FullName.new('Zoe', 'Doe'),
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

    @user = User.new(
      username: 'zoedoe',
      password: 'password123',
      person: @person
    )
  end

  test 'valid user' do
    assert_equal 'Zoe', @user.person.name.first_name
    assert_equal 'zoe@example.com', @user.person.contact_information.email_address.address
    assert_equal 'zoedoe', @user.username
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
    assert_equal 'Doe', @user.person.name.last_name

    handled = false

    DomainEventPublisher.instance.subscribe(PersonNameChanged) do |a_domain_event|
      assert_equal 'Zoe', a_domain_event.name.first_name
      assert_equal 'Jones-Doe', a_domain_event.name.last_name
      handled = true
    end

    @user.change_person_name(FullName.new('Zoe', 'Jones-Doe'))
    assert_equal 'Jones-Doe', @user.person.name.last_name

    assert_equal true, handled
  end

  test 'equality compares tenant and username' do       
    assert_equal User.new(
      username: 'zoedoe', 
      password: 'pass123', 
      person: @person
    ), User.new(
      username: 'zoedoe', 
      password: 'pass123',
      person: @person
    )

    assert_not_equal User.new(
      username: 'johnny', 
      password: 'pass123', 
      person: @person
    ), User.new(
      username: 'zoedoe', 
      password: 'pass123',
      person: @person
    )
  end
end