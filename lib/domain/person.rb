class Person
  include Concerns::Assertion

  attr_reader :name, :contact_information

  def initialize(a_tenant_id, a_name, a_contact_information)
    self.tenant_id = a_tenant_id
    self.name = a_name
    self.contact_information = a_contact_information
  end

  def tenant_id=(a_tenant_id)
    assert_presence(a_tenant_id, 'The tenant id is required')
    @tenant_id = a_tenant_id
  end

  def name=(a_name)
    assert_presence(a_name, 'The person name is required')
    @name = a_name
  end
  
  def contact_information=(a_contact_information)
    assert_presence(a_contact_information, 'The person contact information is required')
    @contact_information = a_contact_information
  end

  def change_name(a_name)
    self.name = a_name

    DomainEventPublisher.instance.publish(
      PersonNameChanged.new(
        @user.username, 
        a_name
      )
    )
  end

  def change_contact_information(a_contact_information)
    self.contact_information = a_contact_information

    DomainEventPublisher.instance.publish(
      PersonContactInformationChanged.new(
        @user.username, 
        a_contact_information
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

  def internal_only_user=(an_user)
    @user = an_user
  end
end