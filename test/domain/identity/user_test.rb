require './test/domain/identity_access_test'

class UserTest < IdentityAccessTest
  test 'register user' do
    tenant = tenant_aggregate
    handled = false

    DomainEventPublisher.subscribe(UserRegistered) do |domain_event|
      assert_equal FIXTURE_USERNAME, domain_event.username
      assert_equal 'Zoe Doe', domain_event.name.as_formatted_name
      assert_equal FIXTURE_USER_EMAIL_ADDRESS, domain_event.email_address.address
      handled = true
    end

    User.new(
      tenant_id: tenant.tenant_id,
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity_for(tenant)
    )

    assert handled
  end

  test 'enablement enabled' do
    user = user_aggregate

    assert user.enabled?
  end

  test 'enablement disabled' do
    user = user_aggregate

    handled = false
    DomainEventPublisher.subscribe(UserEnablementChanged) do |domain_event|
      assert_equal user.username, domain_event.username
      handled = true
    end

    user.define_enablement(Enablement.new(enabled: false))

    assert !user.enabled?
    assert handled
  end

  test 'enablement outside date interval' do
    user = user_aggregate

    assert user.enabled?

    handled = false
    DomainEventPublisher.subscribe(UserEnablementChanged) do |domain_event|
      assert_equal user.username, domain_event.username
      handled = true
    end

    user.define_enablement(Enablement.new(enabled: true, start_at: Date.tomorrow, end_at: Date.tomorrow + 1.day))

    assert !user.enabled?
    assert handled
  end

  test 'enablement within date interval' do
    user = user_aggregate

    assert user.enabled?

    handled = false
    DomainEventPublisher.subscribe(UserEnablementChanged) do |domain_event|
      assert_equal user.username, domain_event.username
      handled = true
    end

    user.define_enablement(Enablement.new(enabled: true, start_at: Date.yesterday, end_at: Date.tomorrow))

    assert user.enabled?
    assert handled
  end

  test 'user descriptor' do
    user = user_aggregate

    assert_equal FIXTURE_USER_EMAIL_ADDRESS, user.user_descriptor.email_address
    assert_equal FIXTURE_USERNAME, user.user_descriptor.username
  end

  test 'change password' do
    user = user_aggregate
    handled = false
    DomainEventPublisher.subscribe(UserPasswordChanged) do |domain_event|
      assert_equal user.username, domain_event.username
      handled = true
    end

    user.change_password(from: FIXTURE_PASSWORD, to: 'ADifferentPassword')

    assert handled
  end

  test 'change password fails' do
    user = user_aggregate

    error = assert_raise ArgumentError do
      user.change_password(from: 'no clue', to: 'ADifferentPassword')
    end

    assert_equal 'Current password not confirmed', error.message
  end

  test 'password hashed on construction' do
    user = user_aggregate

    assert_not_equal FIXTURE_PASSWORD, user.internal_access_only_encrypted_password
  end

  test 'password hashed on change' do
    user = user_aggregate

    strong_password = DomainRegistry.password_service.generate_strong_password
    user.change_password(from: FIXTURE_PASSWORD, to: strong_password)

    assert_not_equal FIXTURE_PASSWORD, user.internal_access_only_encrypted_password
    assert_not_equal strong_password, user.internal_access_only_encrypted_password
  end

  test 'user person contact information changed' do
    user = user_aggregate
    assert_equal FIXTURE_USER_EMAIL_ADDRESS, user.person.email_address.address

    handled = false

    DomainEventPublisher.subscribe(PersonContactInformationChanged) do |domain_event|
      assert_equal FIXTURE_USER_EMAIL_ADDRESS_2, domain_event.contact_information.email_address.address
      assert_equal user.username, domain_event.username
      handled = true
    end

    user.change_person_contact_information(contact_information_2)
    assert_equal FIXTURE_USER_EMAIL_ADDRESS_2, user.person.email_address.address

    assert handled
  end

  test 'user person name changed' do
    user = user_aggregate

    assert_equal 'Doe', user.person.name.last_name

    handled = false

    DomainEventPublisher.subscribe(PersonNameChanged) do |domain_event|
      assert_equal user.username, domain_event.username
      assert_equal 'Zoe Jones-Doe', domain_event.name.as_formatted_name
      handled = true
    end

    user.change_person_name(FullName.new('Zoe', 'Jones-Doe'))
    assert_equal 'Jones-Doe', user.person.name.last_name

    assert handled
  end

  test 'equality compares tenant and username' do
    tenant = tenant_aggregate

    assert_equal User.new(
      tenant_id: tenant.tenant_id,
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD ,
      enablement: Enablement.new(enabled: true),
      person: person_entity_for(tenant)
    ), User.new(
      tenant_id: tenant.tenant_id,
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity_for(tenant)
    )

    assert_not_equal User.new(
      tenant_id: tenant.tenant_id,
      username: FIXTURE_USERNAME_2,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity_for(tenant)
    ), User.new(
      tenant_id: tenant.tenant_id,
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      enablement: Enablement.new(enabled: true),
      person: person_entity_for(tenant)
    )
  end
end