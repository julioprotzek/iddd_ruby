class PersonContactInformationChanged
  attr_reader :version, :occurred_at, :username, :contact_information

  def initialize(username:, contact_information:)
    @version = 1
    @occurred_at = Time.now
    @username = username
    @contact_information = contact_information
  end
end