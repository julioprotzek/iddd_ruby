class Person
  include Assertion

  attr_reader :name, :contact_information

  def initialize(tenant_id, name, contact_information)
    self.tenant_id = tenant_id
    self.name = name
    self.contact_information = contact_information
  end

  def tenant_id=(tenant_id)
    assert_presence(tenant_id, 'The tenant id is required')
    @tenant_id = tenant_id
  end

  def name=(name)
    assert_presence(name, 'The person name is required')
    @name = name
  end

  def contact_information=(contact_information)
    assert_presence(contact_information, 'The person contact information is required')
    @contact_information = contact_information
  end

  def change_name(name)
    self.name = name

    DomainEventPublisher.publish(
      PersonNameChanged.new(
        @user.username,
        name
      )
    )
  end

  def change_contact_information(contact_information)
    self.contact_information = contact_information

    DomainEventPublisher.publish(
      PersonContactInformationChanged.new(
        @user.username,
        contact_information
      )
    )
  end

  def email_address
    contact_information.email_address
  end

  def ==(other)
    self.class == other.class &&
    self.name == other.name &&
    self.contact_information == other.contact_information
  end

  def internal_only_user=(user)
    @user = user
  end
end