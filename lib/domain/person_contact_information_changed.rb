class PersonContactInformationChanged
  attr_reader :version, :occurred_at, :username, :contact_information

  def initialize(an_username, a_contact_information)
    @version = 1
    @occurred_at = Time.now
    @username = an_username
    @contact_information = a_contact_information
  end
end