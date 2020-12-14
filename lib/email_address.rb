class EmailAddress
  include Concerns::Assertion  
  attr_reader :address
  EMAIL_FORMAT = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/

  def initialize(an_address)
    assert_argument_presence(an_address, 'The email address is required.')
    assert_argument_length(an_address, 1, 100, 'The email address must be 100 characters or less.')
    assert_argument_true(an_address.match?(EMAIL_FORMAT), 'Email address format is invalid.')

    @address = an_address
  end
end