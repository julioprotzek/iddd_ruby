require './test/domain/identity_access_test'

class UserTest < IdentityAccessTest
  test 'register user' do
    handled = false

    DomainEventPublisher.instance.subscribe(UserRegistered) do |a_domain_event|
      assert_equal FIXTURE_USERNAME, a_domain_event.username
      assert_equal 'Zoe Doe', a_domain_event.name.as_formatted_name
      assert_equal FIXTURE_USER_EMAIL_ADDRESS, a_domain_event.email_address.address
      handled = true
    end

    user = User.new(
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity
    )

    assert handled
  end

  test 'enablement disabled' do
    user = user_aggregate

    assert user.enabled?

    handled = false
    DomainEventPublisher.instance.subscribe(UserEnablementChanged) do |a_domain_event|
      assert_equal user.username, a_domain_event.username
      handled = true
    end

    user.define_enablement(Enablement.new(enabled: false))

    assert !user.enabled?
    assert handled
  end

  test 'change password' do
    user = user_aggregate
    handled = false
    DomainEventPublisher.instance.subscribe(UserPasswordChanged) do |a_domain_event|
      assert_equal user.username, a_domain_event.username
      handled = true
    end

    user.change_password(FIXTURE_PASSWORD, 'ADifferentPassword')

    assert handled
  end

  test 'user person contact information changed' do   
    user = user_aggregate
    assert_equal FIXTURE_USER_EMAIL_ADDRESS, user.person.contact_information.email_address.address

    handled = false

    DomainEventPublisher.instance.subscribe(PersonContactInformationChanged) do |a_domain_event|
      assert_equal FIXTURE_USER_EMAIL_ADDRESS_2, a_domain_event.contact_information.email_address.address
      assert_equal user.username, a_domain_event.username
      handled = true
    end

    user.change_person_contact_information(contact_information_2)
    assert_equal FIXTURE_USER_EMAIL_ADDRESS_2, user.person.contact_information.email_address.address

    assert handled
  end

  test 'user person name changed' do    
    user = user_aggregate

    assert_equal 'Doe', user.person.name.last_name

    handled = false

    DomainEventPublisher.instance.subscribe(PersonNameChanged) do |a_domain_event|
      assert_equal user.username, a_domain_event.username
      assert_equal 'Zoe Jones-Doe', a_domain_event.name.as_formatted_name
      handled = true
    end

    user.change_person_name(FullName.new('Zoe', 'Jones-Doe'))
    assert_equal 'Jones-Doe', user.person.name.last_name

    assert handled
  end

  test 'equality compares tenant and username' do       
    assert_equal User.new(
      username: FIXTURE_USERNAME, 
      password: FIXTURE_PASSWORD ,
      enablement: Enablement.new(enabled: true),
      person: person_entity
    ), User.new(
      username: FIXTURE_USERNAME, 
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity
    )

    assert_not_equal User.new(
      username: FIXTURE_USERNAME_2, 
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity
    ), User.new(
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity
    )
  end
end