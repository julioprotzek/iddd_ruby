require './test/test_helper'

class IdentityAccessTest < ActiveSupport::TestCase
  FIXTURE_PASSWORD = 'SecretPassword@123'
  FIXTURE_USER_EMAIL_ADDRESS = 'jdoe@example.com'
  FIXTURE_USER_EMAIL_ADDRESS_2 = 'zdoe@example.com'
  FIXTURE_USERNAME = 'jdoe'
  FIXTURE_USERNAME_2 = 'zdoe'

  setup do
    DomainEventPublisher.instance.reset
  end

  def contact_information
    ContactInformation.new(
      EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS),
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
  end

  def contact_information_2
    ContactInformation.new(
      EmailAddress.new(FIXTURE_USER_EMAIL_ADDRESS_2),
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
  end

  def person_entity
    Person.new(
      FullName.new('Zoe', 'Doe'),
      contact_information
    )
  end

  def person_entity_2
    Person.new(
      FullName.new('Zoe', 'Doe'),
      contact_information_2
    )
  end

  def user_aggregate
    User.new(
      username: FIXTURE_USERNAME,
      password: FIXTURE_PASSWORD,
      person: person_entity
    )
  end

  def user_aggregate_2
    User.new(
      username: FIXTURE_USERNAME_2,
      password: FIXTURE_PASSWORD,
      person: person_entity_2
    )
  end
end