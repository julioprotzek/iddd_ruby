class EmailAddress
  include Assertion
  attr_reader :address
  EMAIL_FORMAT = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/

  def initialize(an_address)
    assert_presence(an_address, 'The email address is required.')
    assert_length(an_address, 1, 100, 'The email address must be 100 characters or less.')
    assert(an_address.match?(EMAIL_FORMAT), 'Email address format is invalid.')

    @address = an_address
  end

  def ==(other)
    self.class == other.class && address == other.address
  end
end