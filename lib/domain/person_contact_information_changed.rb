class PersonContactInformationChanged
  attr_reader :version, :occurred_at, :contact_information

  def initialize(a_contact_information)
    @version = 1
    @occurred_at = Time.now
    @contact_information = a_contact_information
  end
end